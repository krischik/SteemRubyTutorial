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

# The Amount class is used in most Scripts so it was
# moved into a separate file.

require_relative 'Steem/Amount'

class Vesting < Steem::Type::BaseType
   include Contracts::Core
   include Contracts::Builtin

   attr_reader :id, :delegator, :delegatee, :vesting_shares, :min_delegation_time

   ##
   #
   Contract HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]] ]] => nil
   def initialize(value)
      super(:id, value)

      @id                  = value.id
      @delegator           = value.delegator
      @delegatee           = value.delegatee    
      @vesting_shares      = Amount.new (value.vesting_shares)
      @min_delegation_time = Time.strptime(value.min_delegation_time + ":Z" , "%Y-%m-%dT%H:%M:%S:%Z")

      return
   end

   ##
   # Create a colorised string from the instance. The vote
   # percentages are multiplied with 100 and are colorised
   # (positive values are printed in green, negative values
   # in red and zero votes (yes they exist) are shown in
   # grey), for improved human readability.
   #
   # @return [String]
   #    formatted value
   #
   Contract None => String
   def to_ansi_s
      # All the magic happens in the `%` operators which
      # calls sprintf which in turn formats the string.
      return (
         "%1$10d | " +
         "%2$-16s ⇒ " +
         "%3$-16s | " +
         "%4$-68s | " +
         "%5$20s | ") % [
            @id,
            @delegator,
            @delegatee,
            @vesting_shares.to_ansi_s,
            @min_delegation_time.strftime("%Y-%m-%d %H:%M:%S")
         ]
   end

   ##
   # Check if delegation is related to the account
   # either as delegator or delegatee.
   #
   # @param [Array<String>] accounts
   #     account to check against vesting.
   # @return [Boolean]
   #     true is the account is either a delegator
   #     or delegatee.
   #
   Contract ArrayOf[String] => Bool
   def is_accounts (accounts)
      return (accounts.include? @delegator) || (accounts.include? @delegatee)
   end

   ##
   # Print a list a vesting values:
   #
   # 1. Loop over all vesting.
   # 2. convert the vote JSON object into the ruby `Vesting` class.
   # 3. print as ansi strings.
   #
   # @param [Array<Hash>] vesting
   #     list of vesting
   #
   Contract ArrayOf[HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]] ]] ], ArrayOf[String] => nil
   def self.print_list (vesting, accounts)
      vesting.each do |vest|
         _vest = Vesting.new vest

         if _vest.is_accounts accounts then
            puts _vest.to_ansi_s
         end
      end

      return
   end

   ##
   # Print the vesting from user:
   #
   # @param [Array<String>] accounts
   #     the accounts to search.
   #
   Contract ArrayOf[String] => nil
   def self.print_accounts (accounts)

      puts ("-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+")

      # `get_vesting_delegations` returns the delegations
      # of multiple accounts at once. Useful if you want
      # to iterate over all existing delegations. It's also
      # the only way to find delegatees.
      #
      # The start parameter takes the delegator / delegatee
      # pair to start the search, limit is the maximum amount
      # of results to be returned (less then 1000) and order
      # is always "by_delegation".
      #
      # The loop needed is pretty complicated as the last
      # element on each iteration is duplicated as first
      # element of the next iteration.

      # empty strings denotes start of list

      _previous_end = ["", ""]

      loop do
         # get the next 1000 items.
         # 
         _vesting = Database_Api.list_vesting_delegations(start: _previous_end, limit: 10, order: "by_delegation")

         # no elements found, end loop now. This only
         # happens when the initial delegator / delegatee
         # pair doesn't exist.

      break if _vesting == nil || _vesting.result.length == 0

         _last_vest = Vesting.new _vesting.result.delegations.pop         
         _current_end = [_last_vest.delegator, _last_vest.delegatee]

         if _previous_end == _current_end then 
            if _last_vest.is_accounts accounts then
               puts _last_vest.to_ansi_s 
            end

            break
         else
            Vesting.print_list(_vesting.result.delegations, accounts)
            
            _previous_end = _current_end
         end
      end

      return
   end
end

begin
   # create instance to the steem condenser API which
   # will give us access to to the global properties and
   # median history

   Condenser_Api = Steem::CondenserApi.new

   # read the global properties and median history values
   # and calculate the conversion Rate for steem to SBD
   # We use the Amount class from Part 2 to convert the
   # string values into amounts.

   _median_history_price = Condenser_Api.get_current_median_history_price.result
   _base                 = Amount.new _median_history_price.base
   _quote                = Amount.new _median_history_price.quote
   SBD_Median_Price      = _base.to_f / _quote.to_f

   _global_properties        = Condenser_Api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Amount.new _global_properties.total_vesting_fund_steem
   _total_vesting_shares     = Amount.new _global_properties.total_vesting_shares
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

   # create instance to the steem database API

   Database_Api = Steem::DatabaseApi.new

rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

if ARGV.length == 0 then
   puts "
Steem-Dump-Accounts — Dump account infos from Steem database

Usage:
   Steem-Dump-Accounts account_name …

"
else
   # read arguments from command line

   Account_Names = ARGV

   puts ("        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |")

   Vesting.print_accounts Account_Names
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
