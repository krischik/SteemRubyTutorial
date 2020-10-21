#!/usr/bin/env ruby
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

# use the "steem.rb" file from the radiator gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "radiator", :version=>'1.0.0', :require => "steem"

require 'colorize'
require 'contracts'

# The Amount class is used in most Scripts so it was
# moved into a separate file.

require_relative 'Radiator/Chain'
require_relative 'Radiator/Amount'
require_relative 'Radiator/Reward_Fund'

##
# Store the chain name for convenience.
#
Chain = Chain_Options[:chain]

##
# Class to handle vote values from postings.
#
# Information on the postings are accessed via the
# `get_active_votes` method of the `CondenserApi`. The method
# takes two parameter: the authors name and the id of the posting.
# Both can be extracted from the URL of the posting. As Result you
# get an array of voting results:
#
# | Name      | Desciption                                  |
# |-----------|---------------------------------------------|
# |voter      | The author account name of the vote.        |
# |percent    | Percent of vote.                            |
# |weight     | Weight of the voting power.                 |
# |rshares    | Reward shares.                              |
# |reputation | The reputation of the account that voted.   |
# |time       | Time the vote was submitted.                |
#
class Vote < Radiator::Type::Serializer
   include Contracts::Core
   include Contracts::Builtin

   attr_reader :voter, :percent, :weight, :rshares, :reputation, :time

   ##
   # Create a new instance from the data returned from
   # the `get_active_votes` method.
   #
   # Percent is a fixed numbers with 4 decimal places and
   # need to be divided by 10000 to make the value
   # mathematically correct and easier to handle. Floats
   # are not as precise as fixed numbers so this is only
   # acceptable because we calculate estimates and not
   # final values.
   #
   # Steem is using an unusual date time format which is
   # missing the timezone indicator. Hence the special
   # scanner and the adding of the Z timezone indicator.
   #
   # rshares is the rewards share the votes gets from the
   # reward pool.
   #
   # reputation is always 0
   #
   # @param [Hash] value
   #     the data hash from the get_active_votes
   #
   Contract HashOf[String => Or[String, Num]] => nil
   def initialize(value)
      super(:vote, value)

      @voter      = value.voter
      @percent    = value.percent / 10000.0
      @weight     = value.weight.to_i
      @rshares    = value.rshares.to_i
      @reputation = value.reputation.to_i
      @time       = Time.strptime(value.time + ":Z", "%Y-%m-%dT%H:%M:%S:%Z")

      return
   end

   ##
   # calculate the vote estimate from the rshares.
   #
   # @return [Float]
   #    the vote estimate in SBD
   #
   Contract None => Num
   def estimate
      return @rshares.to_f / Recent_Claims * Reward_Balance.to_f * SBD_Median_Price
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
      _percent  = @percent * 100.0
      _estimate = estimate

      return(
         (
         "%1$-16s | " + "%2$7.2f%%".colorize(
            if _percent > 0.0 then
               :green
            elsif _percent < -0.0 then
               :red
            else
               :white
            end
         ) +
            " |" + "%3$10.3f SBD".colorize(
            if _estimate > 0.0005 then
               :green
            elsif _estimate < -0.0005 then
               :red
            else
               :white
            end
         ) +
            " |%4$10d |%5$16d |%6$20s |"
         ) % [
            @voter,
            _percent,
            _estimate,
            @weight,
            @rshares,
            @time.strftime("%Y-%m-%d %H:%M:%S")
         ])
   end

   class << self
      ##
      # Print a list a vote values:
      #
      # 1. Loop over all votes.
      # 2. convert the vote JSON object into the ruby `Vote` class.
      # 3. print as ansi strings.
      #
      # @param [Array<Hash>] votes
      #     list of votes
      #
      Contract ArrayOf[HashOf[String => Or[String, Num]]] => nil
      def print_list (votes)
         # used to calculate the total vote value
         _total_estimate = 0.0

         votes.each do |_vote|
            _vote = Vote.new _vote

            puts _vote.to_ansi_s

            # add up extimate
            _total_estimate = _total_estimate + _vote.estimate
         end

         # print the total estimate after the last vote
         puts((
              "Total vote value |          |" +
                 "%1$10.3f SBD".colorize(
                    if _total_estimate > 0.0005 then
                       :green
                    elsif _total_estimate < -0.0005 then
                       :red
                    else
                       :white
                    end
                 ) +
                 " |           |                 |                     |"
              ) % [
            _total_estimate
         ])

         return
      end

      ##
      # Print the votes from a postings given as URLs:
      #
      # 1. Extract the posting ID and author name from the URL
      #    with standard string operations.
      # 2. Print a short header
      # 3. Request the list of votes from `Condenser_Api`
      #    using `get_active_votes`
      # 4. print the votes.
      #
      # @param [String] url
      #     URL of the posting.
      #
      Contract String => nil
      def print_url (url)
         _slug              = url.split('@').last
         _author, _permlink = _slug.split('/')

         puts(("Post Author      : " + "%1$s".blue) % _author)
         puts(("Post ID          : " + "%1$s".blue) % _permlink)
         puts("Voter name       |  percent |         value |    weight |         rshares |    vote date & time |")
         puts("-----------------+----------+---------------+-----------+-----------------+---------------------+")

         Condenser_Api.get_active_votes(_author, _permlink) do |votes|
            if votes.length == 0 then
               puts "No votes found.".yellow
            else
               Vote.print_list votes
            end
         rescue => error
            Kernel::abort(("Error reading posting “%1$s”:\n".red + "%2$s") % [_permlink, error.to_s])
         end

         return
      end # print_url
   end # self
end

begin
   # create instance to the steem condenser API which
   # will give us access to the active votes.

   Condenser_Api = Radiator::CondenserApi.new Chain_Options

   # read the global properties and median history values
   # and calculate the conversion Rate for steem to SBD
   # We use the Amount class from Part 2 to convert the
   # string values into amounts.

   _median_history_price = Condenser_Api.get_current_median_history_price.result
   _base                 = Radiator::Type::Amount.new(_median_history_price.base, Chain)
   _quote                = Radiator::Type::Amount.new(_median_history_price.quote, Chain)
   SBD_Median_Price      = _base.to_f / _quote.to_f

   # read the reward funds. `get_reward_fund` takes one
   # parameter is always "post" and extract variables
   # needed for the vote estimate. This is done just once
   # here to reduce the amount of string parsing needed.
   # `get_reward_fund` takes one parameter is always "post".

   _reward_fund   = Radiator::Type::Reward_Fund.get Chain
   Recent_Claims  = _reward_fund.recent_claims
   Reward_Balance = _reward_fund.reward_balance

rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

# Display help if no URL are given.

if ARGV.length == 0 then
   puts "
Steem-Print-Posting-Votes — Print voting on account.

Usage:
   Steem-Print-Posting-Votes URL …
"
else
   # Loop over all URLs given and print the values using
   # the Vote class.

   ARGV.each do |_url|
      Vote.print_url _url
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
