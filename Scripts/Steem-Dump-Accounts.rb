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

# use the "steem.rb" file from the steem-ruby gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
require 'steem'

if ARGV.length == 0 then
   puts "
Steem-Dump-Accounts — Dump account infos from Steem database

Usage:
   Steem-Dump-Accounts account_name …

"

else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Steem::DatabaseApi.new

   # request account information from the Steem database
   # and print out the accounts found using pretty print
   # (pp) or print out error information when an error
   # occurred.

   Database_Api.find_accounts(accounts: Account_Names) do |result|
      Accounts = result.accounts

      if Accounts.length == 0 then
         puts "No accounts found.".yellow
      else
         pp Accounts
      end
   rescue => error
      Kernel::abort("Error reading accounts:\n".red + error.to_s)
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: spell spelllang=en_gb fileencoding=utf-8 :
