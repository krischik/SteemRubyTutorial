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

   Contract HashOf[String => Or[String, Num]] => nil
   def initialize(value)
      super(:vesting, value)

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

   # read the reward funds. `get_reward_fund` takes one
   # parameter is always "post" and extract variables
   # needed for the vote estimate. This is done just once
   # here to reduce the amount of string parsing needed.
   # `get_reward_fund` takes one parameter is always "post".

   _reward_fund   = Condenser_Api.get_reward_fund("post").result
   Recent_Claims  = _reward_fund.recent_claims.to_i
   Reward_Balance = Amount.new _reward_fund.reward_balance

   # create instance to the steem database API

   Database_api = Steem::Database_Api.new

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

   Account_Names.each do |account|
      _vesting = Condenser_Api.get_vesting_delegations(account, "", 100)
    
      _vesting.result do |vest| 
         pp vest

      end
   end

   # pretty print the result. It might look strange to do so
   # outside the begin / rescue but the value is now available
   # in constant for the rest of the script. Do note that
   # using constant is only suitable for short running script.
   # Long running scripts would need to re-read the value
   # on a regular basis.
end


############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
