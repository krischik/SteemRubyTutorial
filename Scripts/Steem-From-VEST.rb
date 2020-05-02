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

require_relative 'Steem/Chain'
require_relative 'Steem/Amount'
require_relative 'Steem/Price'
require_relative 'Steem/Reward_Fund'

##
# Store the chain name and symbols for convenience.
#
Chain      = Chain_Options[:chain]
DEBT_ASSET = Steem::Type::Amount.debt_asset Chain
CORE_ASSET = Steem::Type::Amount.core_asset Chain
VEST_ASSET = Steem::Type::Amount.vest_asset Chain

begin
   # create instance to the steem condenser API which
   # will give us access to the requested chain.

   Condenser_Api = Steem::CondenserApi.new Chain_Options

   # read the global properties. Yes, it's as simple as
   # this. Note the use of result at the end.

   Global_Properties = Condenser_Api.get_dynamic_global_properties.result
rescue => error
   # I am using Kernel::abort so the code snipped
   # including error handler can be copy pasted into other
   # scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

# shows usage help if the no values are given to convert.

if ARGV.length == 0 then
   puts "
Steem-From-VEST — Print convert list of VESTS value to Steem values

Usage:
   Steem-From-VEST values …

"
else
   # read arguments from command line

   Values = ARGV

   # Calculate the conversion Rate. We use the Amount class
   # from Part 2 to convert the sting values into amounts.
   # The chain need to be passed as different chains have
   # different symbols

   _total_vesting_fund_steem = Steem::Type::Amount.new(Global_Properties.total_vesting_fund_steem, Chain)
   _total_vesting_shares     = Steem::Type::Amount.new(Global_Properties.total_vesting_shares, Chain)
   _conversion_rate          = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

   # read the  median history value and Calculate the
   # conversion Rate for Vests to steem backed dollar.
   # We use the Amount class from Part 2 to convert
   # the string values into amounts.

   _median_history_price = Steem::Type::Price.get Chain
   SBD_Median_Price      = _median_history_price.to_f

   # read the reward funds.

   _reward_fund = Steem::Type::Reward_Fund.get Chain

   # extract variables needed for the vote estimate. This
   # is done just once here to reduce the amount of string
   # parsing needed.

   Recent_Claims  = _reward_fund.recent_claims
   Reward_Balance = _reward_fund.reward_balance.to_f

   # iterate over the valued passed in the command line

   Values.each do |value|
      # convert the value to steem by multiplying with the
      # conversion rate and display the value

      _steem = value.to_f * _conversion_rate

      # calculate actual vesting by adding and subtracting
      # delegation as well at the final vest for vote
      # estimate

      _final_vest = value.to_f * 1e6

      # convert the value to steem by multiplying with the
      # calculate the vote value for 100% upvotes

      _weight           = 1.0
      _max_voting_power = 1.0
      _max_power        = (_max_voting_power * _weight) / 50.0
      _max_rshares      = _max_power * _final_vest
      _max_vote_value   = (_max_rshares / Recent_Claims) * Reward_Balance * SBD_Median_Price

      # Print the result using the the correct symbols for the
      # requested chain

      puts "%1$18.6f %2$-5s = %3$15.3f %4$-5s,   100%% Upvote: %5$8.3f %6$-3s" % [
         value,
         VEST_ASSET,
         _steem,
         CORE_ASSET,
         _max_vote_value,
         DEBT_ASSET]
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
