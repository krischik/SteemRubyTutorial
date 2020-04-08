#!/usr/bin/env ruby
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

require 'pp'
require 'colorize'

# initialize access to the steem or hive blockchain.
# The script will initialize the constant Chain_Options
# with suitable parameter for the chain selected with
# the  `CHAIN_ID` environment variable.

require_relative 'Steem/Chain'
require 'steem-mechanize'

# The Amount class is used in most Scripts so it was moved
# into a separate file.

require_relative 'Steem/Amount'

Chain = Chain_Options[:chain]

##
# Maximum retries to be done when an error happens.
#
Max_Retry_Count = if Chain == :hive then
		     5
		  else
		     3
		  end

##
# Maximum requests made per second. Both Steem and
# Hive will fail of to many requests will be done
# in a very short time.
#
# Hive hasn't got the CPU power yet to accept as many
# requests per second as Steem does.
#
Request_Per_Second = if Chain == :hive then
			5.0
		     else
			20.0
		     end
##
# Maximum retries per second made when and error happens
#
# Hive hasn't got the CPU power yet to accept as many
# retries per second as Steem does.
#
Retries_Per_Second = if Chain == :hive then
			0.5
		     else
			1
		     end

##
# Delete the current line on the console.
#
Delete_Line = "\e[1K\r"

##
# Class to hold a vesting delegation
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
class Vesting < Steem::Type::BaseType
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
      @vesting_shares      = Steem::Type::Amount.new(value.vesting_shares, Chain)
      @min_delegation_time = Time.strptime(value.min_delegation_time + ":Z", "%Y-%m-%dT%H:%M:%S:%Z")

      return
   end

   ##
   # Create a colonised string from the instance. The vote
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
      return(
	 (
	 "%1$10d | " +
	    "%2$-16s ⇒ " +
	    "%3$-16s | " +
	    "%4$-68s | " +
	    "%5$20s | "
	 ) % [
	    @id,
	    @delegator,
	    @delegatee,
	    @vesting_shares.to_ansi_s,
	    @min_delegation_time.strftime("%Y-%m-%d %H:%M:%S")
	 ])
   end

   ##
   # Check if delegation is related to the account either
   # as delegator or delegatee.
   #
   # @param [Array<String>] accounts
   #     accounts to check against vesting.
   # @return [Boolean]
   #     true is the account is either a delegator
   #     or delegatee.
   #
   Contract ArrayOf[String] => Bool

   def is_accounts (accounts)
      return (accounts.include? @delegator) || (accounts.include? @delegatee)
   end

   class << self
      ##
      # Prints all vesting values which are related to given
      # list of accounts:
      #
      # 1. Loop over all vesting.
      # 2. Checks is vesting is related to the list of
      #    accounts
      # 3. Convert the vote JSON object into the ruby
      #    `Vesting` class.
      # 4. Print as ansi strings.
      #
      # @param [Array<Hash>] vesting
      #     list of vesting
      #
      Contract ArrayOf[HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]]]]], ArrayOf[String] => nil

      def print_list (vesting, accounts)
	 vesting.each do |vest|
	    _vest = Vesting.new vest

	    if _vest.is_accounts accounts then
	       puts _vest.to_ansi_s
	    end
	 end

	 return
      end

      ##
      # Fetches all the vestings form the database and prints
      # those who are related to the given list of accounts
      #
      # @param [Array<String>] accounts
      #     the accounts to search.
      #
      Contract ArrayOf[String] => nil

      def print_accounts (accounts)

	 puts("-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+")

	 # `get_vesting_delegations` returns the delegations
	 # of multiple accounts at once. Useful if you want
	 # to iterate over all existing delegations. It's also
	 # the only way to find delegatees.
	 #
	 # The start parameter takes the delegator / delegatee
	 # pair to start the search, limit is the maximum
	 # amount of results to be returned (less then 1000)
	 # and order is always "by_delegation".
	 #
	 # The loop needed is pretty complicated as the last
	 # element on each iteration is duplicated as first
	 # element of the next iteration.

	 # empty strings denotes start of list

	 _previous_end = ["", ""]

	 # counter keep track of the amount of retries left

	 _retry_count = Max_Retry_Count

	 loop do
	    # get the next 1000 items.

	    _vesting = Database_Api.list_vesting_delegations(start: _previous_end, limit: 10, order: "by_delegation")

	    # no elements found, end loop now. This only
	    # happens when the initial delegator / delegatee
	    # pair doesn't exist.

	    break if _vesting == nil || _vesting.result.length == 0

	    # get the delegator / delegatee pair of the last
	    #  element

	    _last_vest   = Vesting.new _vesting.result.delegations.pop
	    _current_end = [_last_vest.delegator, _last_vest.delegatee]

	    # Delete the progress indicator.

	    print Delete_Line

	    # check of the delegatee of the current last
	    # element is the same as the last element of the
	    # previous literation. If this happens we have
	    # reached the end of the list

	    if _previous_end == _current_end then
	       # In the last iteration there will also be only
	       # one element which we need to print.

	       if _last_vest.is_accounts accounts then
		  puts _last_vest.to_ansi_s
	       end

	       break
	    else
	       # Print the list.

	       Vesting.print_list(_vesting.result.delegations, accounts)

	       if _previous_end[0] != "steem" && _current_end[0] == "steem" then
		  # The large mayority of delegations are done
		  # by the steem account. Not only will it
		  # take more then an hour to iterate over the
		  # steem delegations there is also a very
		  # high likelihood of a network error
		  # preventing the iteration from finishing.
		  # For this we skip over the steem account.

		  _previous_end = ["steem", "zzzzzzj"]
	       else
		  # remember the delegator / delegatee pair for
		  # the next iteration.

		  _previous_end = _current_end
	       end
	    end

	    # Print the current position of the iteration as
	    # progress indicator for the user.

	    print((
		  "%1$10d | " +
		     "%2$-16s ⇒ " +
		     "%3$-16s ") % [
	       _last_vest.id,
	       _last_vest.delegator,
	       _last_vest.delegatee])

	    # Throttle to 20 http requests per second. That
	    # seem to be the acceptable upper limit for
	    # https://api.steemit.com

	    sleep(1 / Request_Per_Second)

	    # resets the counter that keeps track of the
	    # retries.

	    _retry_count = Max_Retry_Count
#	 rescue => error
#	    if _retry_count == 0 then
#	       # We made Max_Retry_Count repeats ⇒ giving up.
#
#	       print Delete_Line
#	       Kernel::abort(
#		  (
#		  "\nCould not read %1$s with %2$d retrys :\n%3$s".red
#		  ) % [
#		     _previous_end, Max_Retry_Count, error.to_s
#		  ])
#	    end
#
#	    # wait one second before making the next retry
#
#	    _retry_count = _retry_count - 1
#	    sleep 1.0 / Retries_Per_Second
	 end

	 return
      end # print_accounts
   end # self
end # Vesting

begin
   # create instance to the steem condenser API which
   # will give us access to to the global properties and
   # median history

   Condenser_Api = Steem::CondenserApi.new Chain_Options

   # read the global properties and median history values
   # and calculate the conversion Rate for steem to SBD
   # We use the Amount class from Part 2 to convert the
   # string values into amounts.

   _median_history_price = Condenser_Api.get_current_median_history_price.result
   _base                 = Steem::Type::Amount.new(_median_history_price.base, Chain)
   _quote                = Steem::Type::Amount.new(_median_history_price.quote, Chain)
   SBD_Median_Price      = _base.to_f / _quote.to_f

   _global_properties        = Condenser_Api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Steem::Type::Amount.new(_global_properties.total_vesting_fund_steem, Chain)
   _total_vesting_shares     = Steem::Type::Amount.new(_global_properties.total_vesting_shares, Chain)
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

   # create instance to the steem database API

   Database_Api = Steem::DatabaseApi.new Chain_Options

   #rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   # Kernel::abort("\nError reading global properties:\n".red + error.to_s)
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

   puts("        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |")

   Vesting.print_accounts Account_Names
end

print Delete_Line
puts "Finished!".green

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
