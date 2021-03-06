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
require 'contracts'
require 'radiator'

module SCC
   ##
   #  Base class for all steem engine classes. This cales
   #  holds an general constants and a lazy initialization
   #  to the contracts API.
   #
   class Steem_Engine < Radiator::Type::Serializer
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :key, :value

      ##
      # amount of rows read from database in a single query. If
      # the overall results exceeds this limit then make multiple
      # queries. 1000 seem to be the standard for Steem queries.
      #
      QUERY_LIMIT = 1000

      ##
      # query all rows of an table.
      #
      QUERY_ALL = {}

      class << self
	 attr_reader :QUERY_ALL, :QUERY_LIMIT

	 @@contracts_api         = ::Hash.new

	 ##
	 # Access to contracts interface
	 #
	 # @param [Symbol]
	 #      chain to read the symbol from.
	 # @return [Radiator::SSC::Contracts]
	 #     the contracts API.
	 #
	 Contract Symbol => Radiator::SSC::Contracts
	 def contracts_api (chain)
	    unless @@contracts_api.key? chain then
	       @@contracts_api.store(chain, Radiator::SSC::Contracts.new({chain: chain}))
	    end

	    return @@contracts_api[chain]
	 rescue => error
	    Kernel::abort("Error creating contracts API :\n".red + error.to_s)
	 end #contracts
      end # self
   end # Token
end # SCC

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
