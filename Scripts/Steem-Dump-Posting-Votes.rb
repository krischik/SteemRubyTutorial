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

gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'
require 'steem'

class Vote < Steem::Type::BaseType
   include Contracts::Core
   include Contracts::Builtin

   attr_reader :voter, :percent, :weight, :rshares, :reputation, :time

   Contract HashOf[String => Or[String,Num]] => nil
   def initialize(value)
      super(:voter, value)

      @voter      = value.voter
      @percent    = value.percent / 100.0
      @weight     = value.weight
      @rshares    = value.rshares
      @reputation = value.reputation
      @time       = Date.parse value.time

      return
   end

   ##
   # create a colorized string showing the amount in
   # SDB, STEEM and VESTS. The actual value is colorized
   # in blue while the converted values are colorized in
   # grey (aka dark white).
   #
   # @return [String]
   #    formatted value
   #
   Contract None => String
   def to_ansi_s
      return (
      "%1$-16s : " + "%2$3.2f%%".colorize(
         if @percent > 0 then
            :green
         elsif @percent < 0 then
            :red
         else
            :white
         end
      )) % [
         @voter,
         @percent]
   end

   Contract ArrayOf[Any] => nil
   def self.print_list (votes)
      votes.each do |vote|
         _vote = Vote.new vote

         puts _vote.to_ansi_s
      end

      return
   end

   Contract String => nil
   def self.print_url (url)
      _slug = url.split('@').last
      _author, _permlink = _slug.split('/')

      puts ("Post Author      : " + "%1$s".blue) % _author
      puts ("Post ID          : " + "%1$s".blue) % _permlink

      Condenser_Api.get_active_votes(_author, _permlink) do |votes|
         if votes.length == 0 then
            puts "No votes found.".yellow
         else
            pp votes
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
   # will give us access to to the global properties and
   # median history

   Condenser_Api = Steem::CondenserApi.new

rescue => error
   # I am using Kernel::abort so the code snipped
   # including error handler can be copy pasted into other
   # scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

if ARGV.length == 0 then
   puts "
Steem-Print-Posting-Votes — Print voting on account.

Usage:
   Steem-Print-Posting-Votes URL
"
else
   ARGV.each do |_url|
      Vote.print_url _url
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :

