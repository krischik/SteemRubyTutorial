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
require 'steem'

##
# steem-ruby comes with a helpful Steem::Type::Amount class
# to handle account balances. However Steem::Type::Amount
# won't let you access the actual amount as float which is
# quite cumbersome when you want to make calculations.
#
# This class expands Steem::Type::Amount to add the missing
# functions.
#
class Amount < Steem::Type::Amount
   private

      ##
      # @param [Number] value
      #     the numeric value to create an amount from
      # @param [String] asset
      #     the asset type which should be "STEEM", "SBD" or "VESTS"
      # @return [Amount]
      #     the value as amount
      def self.to_amount (value, asset)
         return Amount.new (value.to_s + " " + asset)
      end

   public

      ##
      # return amount as float to be used for calculations
      #
      # @return [Float]
      #     actual amount as float
      #
      def to_f
         return @amount.to_f
      end

      ##
      # convert Vests to level
      #
      # @param [Amount] value
      #     value to convert
      # @return [Number] steem value
      #
      def to_level ()
         _value = @amount.to_f

         return (
         if @asset != 'VESTS' then
            "N/A"
         elsif _value > 1.0e9 then
            "Whale"
         elsif _value > 1.0e8 then
            "Ocra"
         elsif _value > 1.0e7 then
            "Dolphin"
         elsif _value > 1.0e6 then
            "Minnow"
         else
            "Plankton"
         end)
      end

      ##
      # convert Vests to steem
      #
      # @param [Amount] value
      #     value to convert
      # @return [Amount] steem value
      #
      def self.to_steem (value)
         return (
         Amount.new ((
         if value.is_a?(Numeric) then
            value * Conversion_rate
         else
            value.to_f * Conversion_rate
         end).to_s + " STEEM"))
      end

      ##
      # convert Vests to steem
      #
      # @return [Amount] steem value
      #
      def to_steem ()
         raise ArgumentError, 'asset types must be VESTS' if @asset != "VESTS"

         return Amount.to_steem (self)
      end

      ##
      # operator to add two balances for the users convenience
      #
      # @param [Numeric|Amount]
      #     amount to add
      # @return [Float]
      #     result of addition
      #
      def +(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f + right.to_f, @asset)
      end

      ##
      # operator to subtract two balances for the users
      # convenience
      #
      # @param [Numeric|Amount]
      #     amount to subtract
      # @return [Float]
      #     result of subtraction
      #
      def -(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f - right.to_f, @asset)
      end

      ##
      # operator to divert two balances for the users
      # convenience
      #
      # @param [Numeric|Amount]
      #     amount to divert
      # @return [Float]
      #     result of division
      #
      def *(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f * right.to_f, @asset)
      end

      ##
      # operator to divert two balances for the users
      # convenience
      #
      # @param [Numeric|Amount]
      #     amount to divert
      # @return [Float]
      #     result of division
      #
      def /(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f / right.to_f, @asset)
      end
end # Amount

begin
   # create instance to the steem condenser API which
   # will give us access to

   Condenser_Api = Steem::CondenserApi.new

   # read the global properties. Yes, it's as simple as
   # this. Note the use of result at the end.

   Global_Properties = Condenser_Api.get_dynamic_global_properties.result

   # Calculate the conversion Rate. We use the Amount class
   # from Part 2 to convert the string values into amounts.

   Total_vesting_fund_steem = Amount.new Global_Properties.total_vesting_fund_steem
   Total_vesting_shares = Amount.new Global_Properties.total_vesting_shares
   Conversion_rate = Total_vesting_fund_steem.to_f / Total_vesting_shares.to_f
rescue => error
   # I am using Kernel::abort so the code snipped
   # including error handler can be copy pasted into other
   # scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end


##
# print account information for an array of accounts
#
# @param [Array<Object>] accounts
#     the accounts to print
#
def print_account_balances (accounts)
   accounts.each do |account|
      # create an amount instances for each balance to be
      # used for further processing

      _balance = Amount.new account.balance
      _savings_balance = Amount.new account.savings_balance
      _sbd_balance = Amount.new account.sbd_balance
      _savings_sbd_balance = Amount.new account.savings_sbd_balance
      _vesting_shares = Amount.new account.vesting_shares
      _delegated_vesting_shares = Amount.new account.delegated_vesting_shares
      _received_vesting_shares = Amount.new account.received_vesting_shares

      # calculate actual vesting by adding and subtracting delegation.

      _actual_vesting = _vesting_shares - _delegated_vesting_shares + _received_vesting_shares

      # pretty print out the balances. Note that for a
      # quick printout Steem::Type::Amount provides a
      # simple to_s method. But this method won't align the
      # decimal point

      puts ("Account: " + account.name).colorize(:blue)
      puts "  Steem           = %1$15.3f %2$s" % [
         _balance.to_f,
         _balance.asset]
      puts "  Steem Savings   = %1$15.3f %2$s" % [
         _savings_balance.to_f,
         _savings_balance.asset]
      puts "  SBD             = %1$15.3f %2$s" % [
         _sbd_balance.to_f,
         _sbd_balance.asset]
      puts "  SBD Savings     = %1$15.3f %2$s" % [
         _savings_sbd_balance.to_f,
         _savings_sbd_balance.asset]
      puts ("  Steem Power     = %1$15.3f %2$s %3$18.6f %4$s " + "(%5$s)".green) % [
         _vesting_shares.to_steem.to_f,
         _vesting_shares.to_steem.asset,
         _vesting_shares.to_f,
         _vesting_shares.asset,
         _vesting_shares.to_level]
      puts "  Delegated Power = %1$15.3f %2$s %3$18.6f %4$s" % [
         _delegated_vesting_shares.to_steem.to_f,
         _delegated_vesting_shares.to_steem.asset,
         _delegated_vesting_shares.to_f,
         _delegated_vesting_shares.asset]
      puts "  Received Power  = %1$15.3f %2$s %3$18.6f %4$s" % [
         _received_vesting_shares.to_steem.to_f,
         _received_vesting_shares.to_steem.asset,
         _received_vesting_shares.to_f,
         _received_vesting_shares.asset]
      puts "  Actual Power    = %1$15.3f %2$s %3$18.6f %4$s" % [
         _actual_vesting.to_steem.to_f,
         _actual_vesting.to_steem.asset,
         _actual_vesting.to_f,
         _actual_vesting.asset]
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

   Database_Api = Steem::DatabaseApi.new

   # request account information from the Steem database
   # and print out the accounts balances found using a new
   # function or print out error information when an error
   # occurred.

   Database_Api.find_accounts(accounts: Account_Names) do |result|
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
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
