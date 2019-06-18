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

begin
   # create instance to the steem condenser API which
   # will give us access to

   Condenser_Api = Steem::CondenserApi.new

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
Steem_From_VEST — Print convert list of VESTS value to Steem values

Usage:
   Steem-Print-Balances values …

"
else
   # read arguments from command line

   Values = ARGV

   # Calculate the conversion Rate. We use the Amount class
   # from Part 2 to convert the sting values into amounts.

   _total_vesting_fund_steem = Steem::Type::Amount.new Global_Properties.total_vesting_fund_steem
   _total_vesting_shares = Steem::Type::Amount.new Global_Properties.total_vesting_shares
   _conversion_rate = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

   # iterate over the valued passed in the command line

   Values.each do |value|

      # convert the value to steem by multiplying with the
      # conversion rate and display the value

      _steem = value.to_f * _conversion_rate
      puts "%1$18.6f VESTS = %2$15.3f STEEM" % [value, _steem]
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
