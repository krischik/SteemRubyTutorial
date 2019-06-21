#!/opt/local/bin/ruby
############################################################## {{{1 ##########
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
############################################################## }}}1 ##########

# use the "steem.rb" file from the steem-ruby gem. This is only needed if you have
# both steem-api and radiator installed.

gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
require 'steem'


begin
   Condenser_Api = Radiator::CondenserApi.new
   Database_Api = Radiator::DatabaseApi.new

rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end


if ARGV.length == 0 then
   puts "
Steem-Dump-Method — Dump account infos from Steem database

Usage:
   Steem-Dump-Method.rb class method

"
elsif ARGV.length == 1 then
   # read arguments from command line

   Query_Class = ARGV[0]

   # x = JsonRpc.get_methods(Query_Class)
   # x = JsonRpc.get_methods("Radiator::DatabaseApi")

   pp Database_Api.methods

else
   # read arguments from command line

   Query_Class = ARGV[0]
   Query_Method = ARGV[1]

   # create instance to the steem database API

   JsonRpc = Steem::Jsonrpc.new

   # x = JsonRpc.get_signature(Query_Class)
   # x = JsonRpc.get_signature(Steem::DatabaseApi)

end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: spell spelllang=en_gb fileencoding=utf-8 :
