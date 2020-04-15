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

gem "radiator", :version=>'1.0.0', :require => "steem"

require 'pp'
require 'colorize'
require 'radiator'

begin
   # create instance to the steem condenser API which
   # will give us access to the median history price

   Contracts = Radiator::SSC::Contracts.new
rescue => error
   # I am using Kernel::abort so the code snipped
   # including error handler can be copy pasted into other
   # scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

if ARGV.length == 0 then
   puts "
Steem-Print-SSC-Table-Sample — Print first row of a steem engine table.

Usage:
   Steem-Print-SSC-Table-Sample contract_name table_name

"
else
   # read arguments from command line

   _contract = ARGV[0]
   _table    = ARGV[1]

   # the query attribute is mandantory, supply an empty query
   # to receive the first row.

   _row = Contracts.find_one(
      contract: _contract,
      table:    _table,
      query:    {
      }
   )

   if _row == nil then
      puts "No data found, possible reasons:

⑴ The contract does not exist
⑵ The table does not exist
⑶ The table is empty
"
   else
      pp _row
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
