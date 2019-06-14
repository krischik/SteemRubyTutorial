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
require 'contracts'
require 'radiator'

require_relative 'Steem_Engine'

##
#
module SCC
   class Contract < SCC::Steem_Engine
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :name, :owner, :code, :codeHash, :tables

      public

         ##
         # create instance form Steem Engine JSON object.
         #
         # @param [Hash]
         #    JSON object from contract API.
         #    
         Contract Any => nil
         def initialize(contract)
            super(:name, name)

            @owner    = contract.owner
            @code     = contract.code
            @codeHash = contract.codeHash
            @tables   = contract.tables

            return
         end

      class << self
         ##
         #
         #  @param [String] name
         #     name of contract
         #  @return [SCC::Contract]
         #     contract found
         #
         Contract String => SCC::Contract
         def find (name)
            _contract = Steem_Engine.contracts_api.contract name

            return SCC::Contract.new _contract
         end
      end # self
   end # Token
end # SCC

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
