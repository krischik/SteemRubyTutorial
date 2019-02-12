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
      # Create a new Amount from an value and asset.
      #
      # @param [Float] value
      #     the numeric value to create an amount from
      # @param [String] asset
      #     the asset type which should be "STEEM", "SBD" or "VESTS"
      # @return [Amount]
      #     the value as amount
      def self.to_amount (value, asset)
         return Amount.new(value.to_s + " " + asset)
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
      # convert VESTS to level or "N/A" when the value
      # isn't a VEST value.
      #
      # @return [String]
      #     one of Whale, Orca, Dolphin, Minnow, Plankton or "N/A"
      #
      def to_level
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
      # Convert Amount to steem backed dollar
      #
      # @return [Amount]
      #     the amount represented as steem backed dollar
      # @raise [ArgumentError]
      #     not a SBD, STEEM or VESTS value
      #
      def to_sbd
         return (
         case @asset
            when "SBD"
               self.clone
            when "STEEM"
               Amount.to_amount(@amount.to_f * Conversion_Rate_Steem, "SBD")
            when "VESTS"
               self.to_steem.to_sbd
            else
               raise ArgumentError, 'unknown asset type types'
         end)
      end

      ##
      # convert Vests to steem
      #
      # @return [Amount]
      #    a value in VESTS value
      # @raise [ArgumentError]
      #    not a SBD, STEEM or VESTS value
      #
      def to_steem
         return (
         case @asset
            when "SBD"
               Amount.to_amount(@amount.to_f / Conversion_Rate_Steem, "STEEM")
            when "STEEM"
               self.clone
            when "VESTS"
               Amount.to_amount(@amount.to_f * Conversion_Rate_Vests, "STEEM")
            else
               raise ArgumentError, 'unknown asset type types'
         end)
      end

      ##
      # convert Vests to steem
      #
      # @return [Amount]
      #    a value in VESTS value
      # @raise [ArgumentError]
      #    not a SBD, STEEM or VESTS value
      #
      def to_vests
         return (
         case @asset
            when "SBD"
               self.to_steem.to_vests
            when "STEEM"
               Amount.to_amount(@amount.to_f / Conversion_Rate_Vests, "VESTS")
            when "VESTS"
               self.clone
            else
               raise ArgumentError, 'unknown asset type types'
         end)
      end

      ##
      # create colorize string showing the amount in SDB,
      # STEEM and VESTS. The actual value is colorized in
      # blue while the converted values are colorized in
      # grey (aka dark white).
      #
      # @return [String]
      #    formatted value
      #
      def to_ansi_s
         _sbd   = to_sbd
         _steem = to_steem
         _vests = to_vests

         return sprintf(
            "%1$15.3f %2$s".colorize(
               if @asset == "SBD" then
                  :blue
               else
                  :white
               end
            ) + " " + "%3$15.3f %4$s".colorize(
               if @asset == "STEEM" then
                  :blue
               else
                  :white
               end
            ) + " " + "%5$18.6f %6$s".colorize(
               if @asset == "VESTS" then
                  :blue
               else
                  :white
               end
            ),
            _sbd.to_f,
            _sbd.asset,
            _steem.to_f,
            _steem.asset,
            _vests.to_f,
            _vests.asset)
      end

      ##
      # operator to add two balances for the users convenience
      #
      # @param [Numeric|Amount]
      #     amount to add
      # @return [Float]
      #     result of addition
      # @raise [ArgumentError]
      #    values of different asset type
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
      # @raise [ArgumentError]
      #    values of different asset type
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
      # @raise [ArgumentError]
      #    values of different asset type
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
      # @raise [ArgumentError]
      #    values of different asset type
      #
      def /(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f / right.to_f, @asset)
      end
end # Amount

begin
   # create instance to the steem condenser API which
   # will give us access to to the global properties and
   # median history

   Condenser_Api = Steem::CondenserApi.new

   # read the global properties and median history valuse.

   Global_Properties    = Condenser_Api.get_dynamic_global_properties.result
   Median_History_Price = Condenser_Api.get_current_median_history_price.result

   # Calculate the conversion Rate for Vests to steem
   # backed dollar. We use the Amount class from Part 2 to
   # convert the string values into amounts.

   _base                 = Median_History_Price.base
   _quote                = Median_History_Price.quote
   Conversion_Rate_Steem = _base.to_f / _quote.to_f

   # Calculate the conversion Rate for VESTS to steem. We
   # use the Amount class from Part 2 to convert the string
   # values into amounts.

   _total_vesting_fund_steem = Amount.new Global_Properties.total_vesting_fund_steem
   _total_vesting_shares     = Amount.new Global_Properties.total_vesting_shares
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f
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

      _balance                  = Amount.new account.balance
      _savings_balance          = Amount.new account.savings_balance
      _sbd_balance              = Amount.new account.sbd_balance
      _savings_sbd_balance      = Amount.new account.savings_sbd_balance
      _vesting_shares           = Amount.new account.vesting_shares
      _delegated_vesting_shares = Amount.new account.delegated_vesting_shares
      _received_vesting_shares  = Amount.new account.received_vesting_shares

      # calculate actual vesting by adding and subtracting delegation.

      _actual_vesting = _vesting_shares - _delegated_vesting_shares + _received_vesting_shares

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

      puts ("Account: %1$s".blue + +" " + "(%2$s)".green) % [account.name, _vesting_shares.to_level]
      puts ("  SBD             = " + _sbd_balance.to_ansi_s)
      puts ("  SBD Savings     = " + _savings_sbd_balance.to_ansi_s)
      puts ("  Steem           = " + _balance.to_ansi_s)
      puts ("  Steem Savings   = " + _savings_balance.to_ansi_s)
      puts ("  Steem Power     = " + _vesting_shares.to_ansi_s)
      puts ("  Delegated Power = " + _delegated_vesting_shares.to_ansi_s)
      puts ("  Received Power  = " + _received_vesting_shares.to_ansi_s)
      puts ("  Actual Power    = " + _actual_vesting.to_ansi_s)
      puts ("  Account Value   = " + "%1$15.3f %2$s".green) % [
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
