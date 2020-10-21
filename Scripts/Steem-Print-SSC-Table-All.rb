#!/usr/local/opt/ruby/bin/ruby
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

##
# amount of rows read from database in a single query. If
# the overall results exceeds this limit then make multiple
# queries. 1000 seem to be the standard for Steem queries.
#
Query_Limit = 1000

begin
   # create instance to the steem condenser API which
   # will give us access to the median history price

   Contracts = Radiator::SSC::Contracts.new Chain_Options
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
   Steem-Print-SSC-Table-All contract_name table_name [column_name column_value]…

      contract_name  name of contract to which the table belongs
      table_name     table name to print rows from
      column_name    column name to filter result by (optional)
      column_value   value to filter result by (optional)

   If column_name and column_value are left out print all rows.

   If more then one column_name and column_value pair is given then print
   rows which match all the column_value exactly.
"
elsif ARGV.length & 1 != 0 then
   puts "Please supply an even amount of parameter".red
else
   # read arguments from command line. There are two
   # options:
   #
   #   When two parameter are given then print all rows
   #   from a database table.
   #
   #   more then two parameter are given then print the
   #   rows from database which match the criteria given.
   #
   _contract = ARGV.shift
   _table    = ARGV.shift
   _query    = {}

   while ARGV.length >= 2 do
      # the query parameter is a hash table with column
      # names as key and column values as value.
      #
      _query[ARGV.shift] = ARGV.shift
   end

   _current = 0
   loop do
      _rows = Contracts.find(
         contract:   _contract,
         table:      _table,
         query:      _query,
         limit:      Query_Limit,
         offset:     _current,
         descending: false
      )

      # Exit loop when no result set is returned.
      #
      break if (not _rows) || (_rows.length == 0)
      pp _rows

      # Move current by the actual amount of rows returned
      #
      _current = _current + _rows.length
   end

   # at the end of the loop _current holds the total amount
   # of rows returned. If nothing was found _current is 0.
   #
   if _current == 0 then
      puts "No data found, possible reasons:".red + "
   ⑴ The contract doesn't exist
   ⑵ The table doesn't exist
   ⑶ The query doesn't match any rows
   ⑷ The table is empty"
   else
      puts "Found %1$d rows".green % _current
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 ::
