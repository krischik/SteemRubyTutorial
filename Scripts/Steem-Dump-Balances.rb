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

# use the "steem.rb" file from the steem-ruby gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'
require 'steem'

# The Amount class is used in most Scripts so it was
# moved into a separate file.

require_relative 'Steem/Amount'

begin
   # create instance to the steem condenser API which
   # will give us access to to the global properties and
   # median history

   _condenser_api = Steem::CondenserApi.new

   # read the  median history value and
   # Calculate the conversion Rate for Vests to steem
   # backed dollar. We use the Amount class from Part 2 to
   # convert the string values into amounts.

   _median_history_price = _condenser_api.get_current_median_history_price.result
   _base                 = Steem::Type::Amount.new _median_history_price.base
   _quote                = Steem::Type::Amount.new _median_history_price.quote
   SBD_Median_Price      = _base.to_f / _quote.to_f

   # read the global properties and
   # calculate the conversion Rate for VESTS to steem. We
   # use the Amount class from Part 2 to convert the string
   # values into amounts.

   _global_properties        = _condenser_api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Steem::Type::Amount.new _global_properties.total_vesting_fund_steem
   _total_vesting_shares     = Steem::Type::Amount.new _global_properties.total_vesting_shares
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f
rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
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

      _balance                  = Steem::Type::Amount.new account.balance
      _savings_balance          = Steem::Type::Amount.new account.savings_balance
      _sbd_balance              = Steem::Type::Amount.new account.sbd_balance
      _savings_sbd_balance      = Steem::Type::Amount.new account.savings_sbd_balance
      _vesting_shares           = Steem::Type::Amount.new account.vesting_shares
      _delegated_vesting_shares = Steem::Type::Amount.new account.delegated_vesting_shares
      _received_vesting_shares  = Steem::Type::Amount.new account.received_vesting_shares

      # calculate actual vesting by adding and subtracting delegation.

      _total_vests = _vesting_shares - _delegated_vesting_shares + _received_vesting_shares

      # calculate the account value by adding all balances in SBD

      _account_value =
         _balance.to_sbd +
            _savings_balance.to_sbd +
            _sbd_balance.to_sbd +
            _savings_sbd_balance.to_sbd +
            _vesting_shares.to_sbd

      # pretty print out the balances. Note that for a
      # quick printout Steem::Type::Amount provides a
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
      puts("  Account Value   = " + "%1$15.3f %2$s".green) % [
         _account_value.to_f,
         _account_value.asset]
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

   # create instance to the steem database API

   _database_api = Steem::DatabaseApi.new

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
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
