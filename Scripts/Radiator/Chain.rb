#!/usr/bin/env ruby
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
# initialise the Chain_Options as requested by the
# CHAIN_ID environment variable.

# use the "steem.rb" file from the radiator gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "radiator", :version=>'1.0.0', :require => "steem"

require 'radiator'
require 'radiator/chain_config'

# Read the `CHAIN_ID` environment variable and  initialise
# the `Chain_Options` constant with parameters suitable for
# the chain requested.

case ENV["CHAIN_ID"]&.downcase
   when "test"
      Chain_Options = {
	 chain: :test,
      }
   when "hive"
      Chain_Options = {
	 chain: :hive,
      }
   else
      Chain_Options = {
	 chain: :steem,
      }
end

##
# hive has renamed all values with “sbd” and "steem" in the name
# to "hdb" and "hive".
# @param [Hash]
# 	hash returned either by a steem or hive api call
# @param [String]
# 	key name containing "sbd" or "steem"
# @return [Object]
#     the value referenced by the hash key
#
def get_chain_value (hash, key)
   if Chain_Options[:chain] == :hive then
      key.gsub!(/sbd/, 'hbd')
      key.gsub!(/steem/, 'hive')
   end

   return hash[key]
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
