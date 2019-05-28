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
Steem-Print-SSC-Contract — Print account balances.

Usage:
   Steem-Print-SSC-Contract account_name …

"
else
   # read arguments from command line

   _contract = ARGV[0]
   _table = ARGV[1]
   _rows = Contracts.find(
      contract: _contract,
      table: _table,
      query: {
         symbol: ''
      }
   )

   pp _rows

   pp Contracts.find_one(
         contract: "tokens",
         table: "balances",
         query: {
            symbol: "STINGY",
            account: "inertia"
         }
      )

   pp Contracts.find(
         contract: "tokens",
         table: "balances",
         query: {
            symbol: "STINGY"
         }
      )

   pp Contracts.find(
         contract: "tokens",
         table: "balances",
         query: {
            account: "krischik"
         }
      )

#  "  let tableExists = await api.db.tableExists('tokens');\n" +
#  "  if (tableExists === false) {\n" +
#  "    await api.db.createTable('tokens', ['symbol']);\n" +
#  "    await api.db.createTable('balances', ['account']);\n" +
#  "    await api.db.createTable('contractsBalances', ['account']);\n" +
#  "    await api.db.createTable('params');\n" +
   
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
