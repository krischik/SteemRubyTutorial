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

require 'colorize'
require 'contracts'
require 'radiator'

##
# Class to handle vote values from postings.
#
# Information on the postings are accessed via the
# `get_active_votes` method of the `CondenserApi`. The method 
# takes two parameter: the authors name and the id of the posting. 
# Both can be extracted from the URL of the posting. As Result you 
# get an array of voting results:
# 
# | Name      | Desciption                                         |
# |-----------|----------------------------------------------------|
# |voter      |Name of the voter.                                  |
# |percent    |percentage of vote (times 10000).                   |
# |weight     |Used to calculate the vote value.                   |
# |rshares    |Used to calculate the vote value.                   |
# |reputation |Voters reputation. Not used any more and always 0.  |
# |time       |Time and date of the actual vote.                   
#
class Vote < Radiator::Type::Serializer
   include Contracts::Core
   include Contracts::Builtin

   attr_reader :voter, :percent, :weight, :rshares, :reputation, :time

   ##
   # Create a new instance from the data returned from the
   # `get_active_votes` method. The percent is divided by
   # 10000 to make the value mathematically correct.
   #
   # @param [Hash] value
   #     the data hash from the get_active_votes
   #
   Contract HashOf[String => Or[String, Num]] => nil
   def initialize(value)
      super(:vote, value)

      @voter      = value.voter
      @percent    = value.percent / 10000.0
      @weight     = value.weight
      @rshares    = value.rshares
      @reputation = value.reputation
      @time       = Time.strptime(value.time + "Z" , "%Y-%m-%dT%H:%M:%S")

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
      _percent = @percent * 100.0

      return (
      "%1$-16s : " + "%2$7.2f%%".colorize(
         if _percent > 0 then
            :green
         elsif _percent < 0 then
            :red
         else
            :white
         end
      ) + "%3$12d" + "%4$15d" + "%5$20s") % [
         @voter,
         _percent,
         @weight,
         @rshares,
         @time.strftime("%Y-%m-%d %H:%M:%S")]
   end

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
   Contract ArrayOf[HashOf[String => Or[String, Num]] ] => nil
   def self.print_list (votes)
      votes.each do |_vote|
         _vote = Vote.new _vote

         puts _vote.to_ansi_s
      end

      return
   end

   ##
   # Print the votes from a postings given as URLs:
   # 
   # 1. Extract the posting ID and author name from the URL with standard string operations. 
   # 2. Print a short header
   # 3. Request the list of votes from `Condenser_Api` using `get_active_votes`
   # 4. print the votes.
   #
   # @param [String] url
   #     URL of the posting.
   #
   Contract String => nil
   def self.print_url (url)
      _slug              = url.split('@').last
      _author, _permlink = _slug.split('/')

      puts ("Post Author      : " + "%1$s".blue) % _author
      puts ("Post ID          : " + "%1$s".blue) % _permlink
      puts ("Voter name       :  percent      weight        rshares    vote date & time")

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
   end
end

begin
   # create instance to the steem condenser API which
   # will give us access to the active votes.

   Condenser_Api = Radiator::CondenserApi.new
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
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
