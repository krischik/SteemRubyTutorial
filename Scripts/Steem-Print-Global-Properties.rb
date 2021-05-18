#!/opt/local/bin/ruby
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

require 'pp'
require 'colorize'

require_relative 'Radiator/Chain'

##
# Store the chain name for convenience.
#
Chain = Chain_Options[:chain]

begin
   # create instance to the steem condenser API which
   # will give us access to

   Condenser_Api = Radiator::CondenserApi.new Chain_Options

   # read the global properties. Yes, it's as simple as
   # this.

   Global_Properties = Condenser_Api.get_dynamic_global_properties
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

pp Global_Properties

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
