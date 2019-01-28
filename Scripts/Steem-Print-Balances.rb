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
#  MERCHANTABILITY or ENDIFFTNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see «http://www.gnu.org/licenses/».
############################################################# }}}1 ##########

# use the "steem.rb" file from the radiator gem. This is only needed if you have
# both steem-api and radiator installed.

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'radiator'

##
# steem-ruby comes with a helpful Radiator::Type::Amount class to handle
# account balances. However Radiator::Type::Amount won't let you access any
# attributes which makes using the class quite cumbersome.
#
# This class expands Radiator::Type::Amount to add the missing functions
# making it super convenient.
#
class Amount < Radiator::Type::Amount
   ##
   # add the missing attribute reader.
   #
   attr_reader :amount, :precision, :asset, :value

   ##
   # return amount as float to be used for calculations
   #
   # @return [Float]
   #     actual amount as float
   #
   def to_f
     return @amount.to_f
   end # to_f

   ##
   # operator to add two balances for the users convenience
   #
   # @param [Numeric|Amount]
   #     amount to add
   # @return [Float]
   #     result of addition        
   #
   def +(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f + right
      else
         @amount.to_f + right.to_f
      end)
   end

   ##
   # operator to subtract two balances for the users convenience
   #
   # @param [Numeric|Amount]
   #     amount to subtract
   # @return [Float]
   #     result of subtraction        
   #
   def -(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f - right
      else
         @amount.to_f - right.to_f
      end)
   end
end # Amount

##
# print account information for an array of accounts
#
# @param [Array<Object>] accounts
#     the accounts to print#
#
def print_account_balances (accounts)
   accounts.each do |account|
      # create amount instances for balances

      _balance                   = Amount.new account.balance
      _savings_balance           = Amount.new account.savings_balance
      _sbd_balance               = Amount.new account.sbd_balance
      _savings_sbd_balance       = Amount.new account.savings_sbd_balance
      _vesting_shares            = Amount.new account.vesting_shares
      _delegated_vesting_shares  = Amount.new account.delegated_vesting_shares
      _received_vesting_shares   = Amount.new account.received_vesting_shares

      # calculate actual vesting by adding and subtracting delegation.

      _actual_vesting            = _vesting_shares - (_delegated_vesting_shares + _received_vesting_shares)

      # pretty print out the balances. Note that for a quick printout
      # Radiator::Type::Amount provides a simple to_s method. But this method
      # won't align the decimal point

      puts ("Account: " + account.name).colorize(:blue)
      puts "  Steem           = %1$15.3f %2$s" % [_balance.to_f,                  _balance.asset]
      puts "  Steem Savings   = %1$15.3f %2$s" % [_savings_balance.to_f,          _savings_balance.asset]
      puts "  SBD             = %1$15.3f %2$s" % [_sbd_balance.to_f,              _sbd_balance.asset]
      puts "  SBD Savings     = %1$15.3f %2$s" % [_savings_sbd_balance.to_f,      _savings_sbd_balance.asset]
      puts "  Steem Power     = %1$18.6f %2$s" % [_vesting_shares.to_f,           _vesting_shares.asset]
      puts "  Delegated Steem = %1$18.6f %2$s" % [_delegated_vesting_shares.to_f, _delegated_vesting_shares.asset]
      puts "  Received Steem  = %1$18.6f %2$s" % [_received_vesting_shares.to_f,  _received_vesting_shares.asset]
      puts "  Actual Power    = %1$18.6f VESTS" % _actual_vesting
   end

   return
end # Print_Account_Balances

if ARGV.length == 0 then
   puts """
Steem-Print-Balances — Print account balances.

Usage:
   Steem-Print-Balances account_name …

"""
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Radiator::DatabaseApi.new

   # request account information from the Steem database and print out
   # the accounts balances found using a new function or print out error
   # information when an error occurred.

   Result = Database_Api.get_accounts(Account_Names)

   if Result.key?('error') then
      puts "Error reading accounts:".red
      pp Result.error
   elsif Result.result.length == 0 then
      puts "No accounts found.".yellow
   else
      print_account_balances Result.result
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
