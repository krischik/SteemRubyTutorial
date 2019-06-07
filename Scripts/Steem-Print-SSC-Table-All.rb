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

##
# amount of rows read from database in a single query. If
# the overall results exceeds this limit then make multiple
# queries. 1000 seem to be the standard for Steem queries.
#
Query_Limit = 1000

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
Steem-Print-SSC-Table-All — Print rows from a steem engine table.

Usage:
   Steem-Print-SSC-Table-All contract_name table_name [column_name column_value]

      contract_name  name of contract to which the table belongs
      table_name     table name to print rows from
      column_name    column name to filter result by (optional)
      column_value   value to filter result by (optional)

      If column_name and column_value are left out print all rows.
"
elsif not [2,4].include? ARGV.length then
   puts "You need to pass either 2 or 4 parameter.".red
else
   # read arguments from command line. There are two
   # options:
   #
   # 2 parameter: print all rows from a database table.
   # 4 parameter: print rows from database which match
   #              the criteria.

   _contract = ARGV[0]
   _table = ARGV[1]
   _query = {}

   if ARGV.length == 4 then
      # the query parameter is a hash table with column
      # names as key and column values as value.

      _query[ARGV[2]] = ARGV[3]
   end

   _current = 0
   loop do
      _rows = Contracts.find(
         contract: _contract,
         table: _table,
         query: _query,
         limit: Query_Limit,
         offset: _current
      )
   break if _rows.length == 0
      pp _rows

      _current = _current + _rows.length
   end

   puts "Found %1$d rows".green % _current
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 ::
