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
require 'radiator'

# The Amount class is used in most Scripts so it was moved
# into a separate file.

require_relative 'Radiator/Amount'
require_relative 'Radiator/Price'

##
# Class to hold a vesting delegation. The vesting holds the
# following values
#
# @property [Number] id
#     ID unique to all delegations.
# @property [String] delegator
#     Account name of the account who delegates
# @property [String] delegatee
#     Account name of the account who is delegates to
# @property [Amount] vesting_shares
#     Amount
# @property [Time] min_delegation_time
#     Start of delegation
#
class Vesting < Radiator::Type::Serializer
   include Contracts::Core
   include Contracts::Builtin

   attr_reader :id, :delegator, :delegatee, :vesting_shares, :min_delegation_time

   ##
   # Create a new instance
   #
   # @param [Hash] value
   #     a vesting as returned by from
   #     `find_vesting_delegations`,
   #     `get_vesting_delegations` or
   #     `list_vesting_delegations`.
   #
   Contract HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]]]] => nil
   def initialize(value)
      super(:id, value)

      @id                  = value.id
      @delegator           = value.delegator
      @delegatee           = value.delegatee
      @vesting_shares      = Radiator::Type::Amount.new (value.vesting_shares)
      @min_delegation_time = Time.strptime(value.min_delegation_time + ":Z", "%Y-%m-%dT%H:%M:%S:%Z")

      return
   end

   ##
   # Create a colourised string from the instance. The vote
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

   # to_ansi_s

   class << self
      ##
      # Print a list a vesting values:
      #
      # 1. Loop over all vesting.
      # 2. convert the vote JSON object into the ruby
      #    `Vesting` class.
      # 3. print as ansi strings.
      #
      # @param [Array<Hash>] vesting
      #     list of vesting
      #
      Contract ArrayOf[HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]]]]] => nil
      def print_list (vesting)
         vesting.each do |vest|
            _vest = Vesting.new vest

            puts _vest.to_ansi_s
         end

         return
      end

      ##
      # Print the vesting the given account makes:
      #
      # @param [String] account
      #     account of the posting.
      #
      Contract String => nil
      def print_account (account)

         puts ("-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+")

         # `get_vesting_delegations` returns a subset of an
         # accounts delegation. This is helpful for accounts
         # with more then a thousand delegations like steem.
         # The 2nd parameter is the first delegatee to
         # return. The 3nd parameter is maximum amount results
         # to return. Must be less then 1000.
         #
         # The loop needed is pretty complicated as the last
         # element on each iteration is duplicated as first
         # element of the next iteration.

         # empty string denotes start of list

         _previous_delegatee = ""

         loop do
            # get the next 1000 items.

            _vesting = Condenser_Api.get_vesting_delegations(account, _previous_delegatee, 1000)

            # no elements found, end loop now. This only
            # happens when the account doesn't exist.

            break if _vesting.result.length == 0

            # get and remove the last element. The last
            # element meeds to be removed as it will be
            # dupplicated as firt element in the next
            # itteration.

            _last_vest = Vesting.new _vesting.result.pop

            # check of the delegatee of the current last
            # element is the same as the last element of the
            # previous itteration. If this happens we have
            # reached the end of the list

            if _previous_delegatee == _last_vest.delegatee then
               # In the last itteration there will also be
               # only one element which we need to print.

               puts _last_vest.to_ansi_s
               break
            else
               # Print the list.

               Vesting.print_list _vesting.result

               # remember the delegatee for the next
               # interation.

               _previous_delegatee = _last_vest.delegatee
            end
         end

         return
      end # print_account
   end # self
end # Vesting

begin
   # create instance to the steem condenser API which will
   # give us access to to the global properties and median
   # history

   Condenser_Api = Radiator::CondenserApi.new

   # read the global properties and median history values
   # and calculate the conversion Rate for steem to SBD
   # We use the Amount class from Part 2 to convert the
   # string values into amounts.

   _median_history_price = Radiator::Type::Price.new Condenser_Api.get_current_median_history_price.result
   SBD_Median_Price      = _median_history_price.sbd_median_price

   # read the global properties and
   # calculate the conversion Rate for VESTS to steem. We
   # use the Amount class from Part 2 to convert the string
   # values into amounts.

   _global_properties        = Condenser_Api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Radiator::Type::Amount.new _global_properties.total_vesting_fund_steem
   _total_vesting_shares     = Radiator::Type::Amount.new _global_properties.total_vesting_shares
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

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

   Account_Names.each do |account|
      Vesting.print_account account
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
