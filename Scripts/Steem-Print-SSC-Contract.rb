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

require 'pp'
require 'colorize'
require 'radiator'

begin
   # create an instance to the radiator contracts API which
   # will give us access to steem engine contracts

   Contracts = Radiator::SSC::Contracts.new

rescue => error
   # I am using Kernel::abort so the code snipped including
   # error handler can be copy pasted into other scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

if ARGV.length == 0 then
   puts "
Steem-Print-SSC-Contract — Print steem engine contracts.

Usage:
   Steem-Print-SSC-Contract contract_name …
"
else
   # read arguments from command line

   _names = ARGV

   # Loop over provided contact names and print the steen
   # engine contracts.

   _names.each do |_name|

      # read the contract

      _contract = Contracts.contract _name

      # print the contract

      pp _contract
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
