#!/opt/local/bin/ruby
############################################################# {{{1 ##########
#  Copyright © 2019 … 2020 Martin Krischik «krischik@users.sourceforge.net»
#############################################################################
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see «http://www.gnu.org/licenses/».
############################################################# }}}1 ##########

require 'pp'
require 'colorize'
require 'contracts'

# The Amount class is used in most Scripts so it was
# moved into a separate file.

require_relative 'Steem/Chain'
require_relative 'Steem/Reward_Fund'
require_relative 'Steem/Amount'
require_relative 'Steem/Price'

##
# Store the chain name for convenience.
#
Chain      = Chain_Options[:chain]
DEBT_ASSET = Steem::Type::Amount.debt_asset Chain
CORE_ASSET = Steem::Type::Amount.core_asset Chain
VEST_ASSET = Steem::Type::Amount.vest_asset Chain
Five_Days  = 5 * 24 * 60 * 60

begin
   # read the  median history value and
   # Calculate the conversion Rate for Vests to steem
   # backed dollar. We use the Amount class from Part 2 to
   # convert the string values into amounts.

   _median_history_price = Steem::Type::Price.get Chain
   SBD_Median_Price      = _median_history_price.to_f

   # read the reward funds.

   _reward_fund = Steem::Type::Reward_Fund.get Chain

   # extract variables needed for the vote estimate. This
   # is done just once here to reduce the amount of string
   # parsing needed.

   Recent_Claims  = _reward_fund.recent_claims
   Reward_Balance = _reward_fund.reward_balance.to_f
rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

##
# calculate the real voting power of an account. The voting
# power in the database is only updated when the user makes
# an upvote and needs to calculated from there.
#
# From https://github.com/steemit/steem-js/issues/253
#
# const secondsago = (new Date().getTime() - new Date(account.last_vote_time + "Z").getTime()) / 1000;
# const votingPower = account.voting_power + (10000 * secondsago / 432000);
#
# | Name	  | API			    | Description							  |
# |---------------|-------------------------|---------------------------------------------------------------------|
# |last_vote_time |DatabaseApi.get_accounts |Last time the user voted in UTC. Note that the UTC marker is missing |
# |voting_power   |DatabaseApi.get_accounts |Voting power at last vote in %. Fixed point with 4 decimal places	  |
#
# @param [Hash] account
#     account information.
# @return [Float]
#     voting power as float from 0.0000 to 1.0000
#
def real_voting_power (account)
   _mana                     = account.voting_manabar
   _vesting_shares           = Steem::Type::Amount.new(account.vesting_shares, Chain)
   _received_vesting_shares  = Steem::Type::Amount.new(account.received_vesting_shares, Chain)
   _delegated_vesting_shares = Steem::Type::Amount.new(account.delegated_vesting_shares, Chain)
   _total_shares             = _vesting_shares + _received_vesting_shares - _delegated_vesting_shares
   _max_mana                 = _total_shares.to_f * 1000000.0
   _last_vote_time           = Time.strptime(_mana.last_update_time.to_s, "%s")
   _current_time             = Time.now
   _elapsed                  = _current_time - _last_vote_time
   _current_mana             = _mana.current_mana.to_f + _elapsed * _max_mana / Five_Days

   _retval = if _current_mana > _max_mana then
		1.0
	     else
		_current_mana / _max_mana
	     end

   #noinspection RubyYardReturnMatch
   return _retval.round(4)
end

##
# print account information for an array of accounts
#
# @param [Array<Hash>] accounts
#     the accounts to print
#
def print_account_balances(accounts)
   # used to calculate the total value.

   _total_balance		    = Steem::Type::Amount.core_zero Chain
   _total_savings_balance	    = Steem::Type::Amount.core_zero Chain
   _total_xbd_balance		    = Steem::Type::Amount.debt_zero Chain
   _total_savings_xbd_balance	    = Steem::Type::Amount.debt_zero Chain
   _total_vesting_shares	    = Steem::Type::Amount.vest_zero Chain
   _total_delegated_vesting_shares  = Steem::Type::Amount.vest_zero Chain
   _total_received_vesting_shares   = Steem::Type::Amount.vest_zero Chain
   _total_total_vests		    = Steem::Type::Amount.vest_zero Chain
   _total_account_value		    = Steem::Type::Amount.debt_zero Chain

   accounts.each do |account|
      # create an amount instances for each balance to be
      # used for further processing

      _balance                  = Steem::Type::Amount.new(account.balance, Chain)
      _savings_balance          = Steem::Type::Amount.new(account.savings_balance, Chain)
      _xbd_balance              = Steem::Type::Amount.new(get_chain_value(account, 'sbd_balance'), Chain)
      _savings_xbd_balance      = Steem::Type::Amount.new(get_chain_value(account, 'savings_sbd_balance'), Chain)
      _vesting_shares           = Steem::Type::Amount.new(account.vesting_shares, Chain)
      _delegated_vesting_shares = Steem::Type::Amount.new(account.delegated_vesting_shares, Chain)
      _received_vesting_shares  = Steem::Type::Amount.new(account.received_vesting_shares, Chain)
      _voting_power             = real_voting_power account

      # calculate actual vesting by adding and subtracting
      # delegation as well at the final vest for vote
      # estimate

      _total_vests = _vesting_shares - _delegated_vesting_shares + _received_vesting_shares
      _final_vest  = _total_vests.to_f * 1e6

      # calculate the account value by adding all balances in SBD

      _account_value =
	 _balance.to_sbd +
	    _savings_balance.to_sbd +
	    _xbd_balance.to_sbd +
	    _savings_xbd_balance.to_sbd +
	    _vesting_shares.to_sbd

      # calculate the vote value for 100% upvotes

      _weight = 1.0

      # calculate the account's current vote value for a
      # 100% upvote.
      #
      # From https://developers.steem.io/tutorials-recipes/estimate_upvote
      #
      # total_vests = vesting_shares + received_vesting_shares - delegated_vesting_shares
      # final_vest = total_vests * 1e6
      # power = (voting_power * weight / 10000) / 50
      # rshares = power * final_vest / 10000
      # estimate = rshares / recent_claims * reward_balance * sbd_median_price
      #
      # | Name			  | API						 | Description						     |
      # |-------------------------|----------------------------------------------|-----------------------------------------------------------|
      # |weight			  |choose by the user				 |Weight of vote in %. Fixed point with 4 places	     |
      # |voting_power¹		  |calculated from the last vote		 |Voting power at last vote in %.			     |
      # |vesting_shares		  |DatabaseApi.get_accounts			 |VESTS owned by account				     |
      # |received_vesting_shares  |DatabaseApi.get_accounts			 |VESTS delegated from other accounts			     |
      # |delegated_vesting_shares |DatabaseApi.get_accounts			 |VESTS delegated to other accounts			     |
      # |recent_claims		  |CondenserApi.get_reward_fund			 |Recently made claims on reward pool			     |
      # |reward_balance		  |CondenserApi.get_reward_fund			 |Reward pool						     |
      # |sbd_median_price	  |calculated from base and quote		 |Conversion rate steem ⇔ SBD				     |
      # |base			  |CondenserApi.get_current_median_history_price |Conversion rate steem ⇔ SBD				     |
      # |quote			  |CondenserApi.get_current_median_history_price |Conversion rate steem ⇔ SBD				     |
      #
      # ¹ Both the current and the last voting_power is
      #   called voting_power in the official documentation

      _current_power      = (_voting_power * _weight) / 50.0
      _current_rshares    = _current_power * _final_vest
      _current_vote_value = (_current_rshares / Recent_Claims) * Reward_Balance * SBD_Median_Price

      # calculate the account's maximum vote value for a 100% upvote.

      _max_voting_power = 1.0
      _max_power        = (_max_voting_power * _weight) / 50.0
      _max_rshares      = _max_power * _final_vest
      _max_vote_value   = (_max_rshares / Recent_Claims) * Reward_Balance * SBD_Median_Price

      # pretty print out the balances. Note that for a
      # quick printout Steem::Type::Amount provides a
      # simple to_s method. But this method won't align the
      # decimal point

      puts(("Account: %1$s".blue + +" " + "(%2$s)".green) % [account.name, _vesting_shares.to_level])
      puts("  Dept                   = " + _xbd_balance.to_ansi_s)
      puts("  Dept Savings           = " + _savings_xbd_balance.to_ansi_s)
      puts("  Core                   = " + _balance.to_ansi_s)
      puts("  Core Savings           = " + _savings_balance.to_ansi_s)
      puts("  Power                  = " + _vesting_shares.to_ansi_s)
      puts("  Delegated Power        = " + _delegated_vesting_shares.to_ansi_s)
      puts("  Received Power         = " + _received_vesting_shares.to_ansi_s)
      puts("  Actual Power           = " + _total_vests.to_ansi_s)
      puts(("  Voting Power           = " +
	 "%1$15.3f %3$-3s".colorize(
	    if _voting_power == 1.0 then
	       :green
	    else
	       :red
	    end
	 ) + " of " + "%2$1.3f %3$-3s".blue) % [
	 _current_vote_value,
	 _max_vote_value,
	 DEBT_ASSET])
      puts(("  Account Value          = " + "%1$15.3f %2$s".green) % [
	 _account_value.to_f,
	 _account_value.asset])

      _total_balance		       = _total_balance			 + _balance
      _total_savings_balance	       = _total_savings_balance		 + _savings_balance
      _total_xbd_balance	       = _total_xbd_balance		 + _xbd_balance
      _total_savings_xbd_balance       = _total_savings_xbd_balance	 + _savings_xbd_balance
      _total_vesting_shares	       = _total_vesting_shares		 + _vesting_shares
      _total_delegated_vesting_shares  = _total_delegated_vesting_shares + _delegated_vesting_shares
      _total_received_vesting_shares   = _total_received_vesting_shares  + _received_vesting_shares
      _total_total_vests	       = _total_total_vests		 + _total_vests
      _total_account_value	       = _total_account_value		 + _account_value
   end

   # no need to print a grand total when there was only one account
   # found.

   if accounts.length > 1 then
      puts "All Account: ".blue
      puts("  Dept                   = " + _total_xbd_balance.to_ansi_s)
      puts("  Dept Savings           = " + _total_savings_xbd_balance.to_ansi_s)
      puts("  Core                   = " + _total_balance.to_ansi_s)
      puts("  Core Savings           = " + _total_savings_balance.to_ansi_s)
      puts("  Power                  = " + _total_vesting_shares.to_ansi_s)
      puts("  Delegated Power        = " + _total_delegated_vesting_shares.to_ansi_s)
      puts("  Received Power         = " + _total_received_vesting_shares.to_ansi_s)
      puts("  Actual Power           = " + _total_total_vests.to_ansi_s)
      puts ("  Total Value            = " + "%1$15.3f %2$s".green.bold) % [
	 _total_account_value.to_f,
	 _total_account_value.asset]
   end

   return
end

if ARGV.length == 0 then
   puts "
Steem-Dump-Balances — Dump account balances.

Usage:
   Steem-Dump-Balances account_name …

"
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API. This is
   # needed to read account information.

   _database_api = Steem::DatabaseApi.new Chain_Options

   # request account information from the Steem database
   # and print out the accounts balances found using a new
   # function or print out error information when an error
   # occurred.

   _database_api.find_accounts(accounts: Account_Names) do |result|
      Accounts = result.accounts

      if Accounts.length == 0 then
	 puts "No accounts found.".yellow
      else
	 # print out the actual account balances.

	 print_account_balances Accounts
      end
   rescue => error
      Kernel::abort("Error reading accounts:\n".red + error.to_s)
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
