#!/opt/local/bin/ruby
############################################################# {{{1 ##########
#  Copyright © 2019 Martin Krischik «krischik@users.sourceforge.net»
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

# use the "steem.rb" file from the radiator gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'
require 'radiator'

# The Amount class is used in most Scripts so it was
# moved into a separate file.

require_relative 'Radiator/Amount'
require_relative 'Radiator/Price'

Five_Days = 5 * 24 * 60 * 60

begin
   # create instance to the steem condenser API which
   # will give us access to to the global properties,
   # median history and reward fund

   _condenser_api = Radiator::CondenserApi.new

   # read the  median history value and
   # Calculate the conversion Rate for Vests to steem
   # backed dollar. We use the Amount class from Part 2 to
   # convert the string values into amounts.

   _median_history_price = Radiator::Type::Price.new _condenser_api.get_current_median_history_price.result
   SBD_Median_Price      = _median_history_price.sbd_median_price

   # read the global properties and
   # calculate the conversion Rate for VESTS to steem. We
   # use the Amount class from Part 2 to convert the string
   # values into amounts.

   _global_properties        = _condenser_api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Radiator::Type::Amount.new _global_properties.total_vesting_fund_steem
   _total_vesting_shares     = Radiator::Type::Amount.new _global_properties.total_vesting_shares
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

   # read the reward funds. `get_reward_fund` takes one
   # parameter is always "post".

   _reward_fund = Radiator::Type::Reward_Fund.get

   # extract variables needed for the vote estimate. This
   # is done just once here to reduce the amount of string
   # parsing needed.

   Recent_Claims  = _reward_fund.recent_claims
   Reward_Balance = _reward_fund.reward_balance
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
# | Name          | API                     | Desciption                                                          |
# |---------------|-------------------------|---------------------------------------------------------------------|
# |last_vote_time |DatabaseApi.get_accounts |Last time the user voted in UTC. Note that the UTC marker is missing |
# |voting_power   |DatabaseApi.get_accounts |Voting power at last vote in %. Fixed point with 4 decimal places    |
#
# @param [Hash] account
#     account informations.
# @return [Float]
#     voting power as float from 0.0000 to 1.0000
#
def real_voting_power (account)
   _last_vote_time = Time.strptime(account.last_vote_time + ":Z", "%Y-%m-%dT%H:%M:%S:%Z")
   _current_time   = Time.now
   _seconds_ago    = _current_time - _last_vote_time
   _voting_power   = account.voting_power.to_f / 10000.0
   _retval         = _voting_power + (_seconds_ago / Five_Days)

   if _retval > 1.0 then
      _retval = 1.0
   end

   return _retval.round(4)
end

##
# print account information for an array of accounts
#
# @param [Array<Hash>] accounts
#     the accounts to print
#
def print_account_balances(accounts)
   accounts.each do |account|
      # create an amount instances for each balance to be
      # used for further processing

      _balance                  = Radiator::Type::Amount.new account.balance
      _savings_balance          = Radiator::Type::Amount.new account.savings_balance
      _sbd_balance              = Radiator::Type::Amount.new account.sbd_balance
      _savings_sbd_balance      = Radiator::Type::Amount.new account.savings_sbd_balance
      _vesting_shares           = Radiator::Type::Amount.new account.vesting_shares
      _delegated_vesting_shares = Radiator::Type::Amount.new account.delegated_vesting_shares
      _received_vesting_shares  = Radiator::Type::Amount.new account.received_vesting_shares
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
            _sbd_balance.to_sbd +
            _savings_sbd_balance.to_sbd +
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
      # | Name                    | API                                          | Desciption                                                |
      # |-------------------------|----------------------------------------------|-----------------------------------------------------------|
      # |weight                   |choosen by the user                           |Weight of vote in %. Fixed point with 4 places             |
      # |voting_power¹            |calculated from the last vote                 |Voting power at last vote in %.                            |
      # |vesting_shares           |DatabaseApi.get_accounts                      |VESTS owned by account                                     |
      # |received_vesting_shares  |DatabaseApi.get_accounts                      |VESTS delegated from other accounts                        |
      # |delegated_vesting_shares |DatabaseApi.get_accounts                      |VESTS delegated to other accounts                          |
      # |recent_claims            |CondenserApi.get_reward_fund                  |Recently made claims on reward pool                        |
      # |reward_balance           |CondenserApi.get_reward_fund                  |Reward pool                                                |
      # |sbd_median_price         |calulated from base and quote                 |Conversion rate steem ⇔ SBD                                |
      # |base                     |CondenserApi.get_current_median_history_price |Conversion rate steem ⇔ SBD                                |
      # |quote                    |CondenserApi.get_current_median_history_price |Conversion rate steem ⇔ SBD                                |
      #
      # ¹ Both the current and the last voting_power is
      #   called voting_power in the official dokumentation

      _current_power      = (_voting_power * _weight) / 50.0
      _current_rshares    = _current_power * _final_vest
      _current_vote_value = (_current_rshares / Recent_Claims) * Reward_Balance.to_f * SBD_Median_Price

      # calculate the account's maximum vote value for a 100% upvote.

      _max_voting_power = 1.0
      _max_power        = (_max_voting_power * _weight) / 50.0
      _max_rshares      = _max_power * _final_vest
      _max_vote_value   = (_max_rshares / Recent_Claims) * Reward_Balance.to_f * SBD_Median_Price

      # pretty print out the balances. Note that for a
      # quick printout Radiator::Type::Amount provides a
      # simple to_s method. But this method won't align the
      # decimal point

      puts("Account: %1$s".blue + +" " + "(%2$s)".green) % [account.name, _vesting_shares.to_level]
      puts("  SBD             = " + _sbd_balance.to_ansi_s)
      puts("  SBD Savings     = " + _savings_sbd_balance.to_ansi_s)
      puts("  Steem           = " + _balance.to_ansi_s)
      puts("  Steem Savings   = " + _savings_balance.to_ansi_s)
      puts("  Steem Power     = " + _vesting_shares.to_ansi_s)
      puts("  Delegated Power = " + _delegated_vesting_shares.to_ansi_s)
      puts("  Received Power  = " + _received_vesting_shares.to_ansi_s)
      puts("  Actual Power    = " + _total_vests.to_ansi_s)
      puts("  Voting Power    = " +
              "%1$15.3f SBD".colorize(
                 if _voting_power == 1.0 then
                    :green
                 else
                    :red
                 end
              ) + " of " + "%2$1.3f SBD".blue) % [
         _current_vote_value,
         _max_vote_value]
      puts("  Account Value   = " + "%1$15.3f %2$s".green) % [
         _account_value.to_f,
         _account_value.asset]
   end

   return
end

if ARGV.length == 0 then
   puts "
Steem-Print-Balances — Print account balances.

Usage:
   Steem-Print-Balances account_name …

"
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API. This is
   # neede to read account informations.

   _database_api = Radiator::DatabaseApi.new

   # request account information from the Steem database
   # and print out the accounts balances found using a new
   # function or print out error information when an error
   # occurred.

   _accounts = _database_api.get_accounts(Account_Names)

   if _accounts.key?('error') then
      Kernel::abort("Error reading accounts:\n".red + _accounts.error.to_s)
   elsif _accounts.result.length == 0 then
      puts "No accounts found.".yellow
   else
      print_account_balances _accounts.result
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
