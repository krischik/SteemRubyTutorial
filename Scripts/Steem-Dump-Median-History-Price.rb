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

# use the "steem.rb" file from the steem-ruby gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "steem-ruby", :version => '1.0.0', :require => "steem"

require 'pp'
require 'colorize'
require_relative 'Steem/Chain'

##
# Store the chain name for convenience.
#
Chain = Chain_Options[:chain]

begin
   # create instance to the steem condenser API which
   # will give us access to the median history price

   Condenser_Api = Steem::CondenserApi.new Chain_Options

   # read the global properties. Yes, it's as simple as
   # this.

   Median_History_Price = Condenser_Api.get_current_median_history_price

   # Calculate the conversion Rate for Vests to steem
   # backed dollar. We use the Amount and Price class from Part 2 to
   # convert the string values into amounts.

   SBD_Median_Price = Steem::Type::Price.new(Median_History_Price.result, Chain)
rescue => error
   # I am using Kernel::abort so the code snipped
   # including error handler can be copy pasted into other
   # scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

# pretty print the result. It might look strange to do so
# outside the begin / rescue but the value is now available
# in constant for the rest of the script. Do note that
# using constant is only suitable for short running script.
# Long running scripts would need to re-read the value
# on a regular basis.

pp Median_History_Price

# show actual conversion rate:

DEBT_ASSET = Steem::Type::Amount.debt_asset Chain
CORE_ASSET = Steem::Type::Amount.core_asset Chain

puts(("1.000 %1$-5s = %2$15.3f %3$-5s") % [CORE_ASSET, 1.0 * SBD_Median_Price.to_f, DEBT_ASSET])
puts(("1.000 %1$-5s = %2$15.3f %3$-5s") % [DEBT_ASSET, 1.0 / SBD_Median_Price.to_f, CORE_ASSET])

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
