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
require 'json'

require_relative 'Steem_Engine'
require_relative 'Metric'

module SCC
   ##
   #
   class Token < SCC::Steem_Engine
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :key, :value,
                  :symbol,
                  :issuer,
                  :name,
                  :metadata,
                  :precision,
                  :max_supply,
                  :supply,
                  :circulating_supply,
                  :loki

      public

         ##
         # create instance form Steem Engine JSON object.
         #
         # @param [Hash]
         #    JSON object from contract API.
         #
         Contract Any => nil
         def initialize(token)
            super(:symbol, token.symbol)

            @symbol             = token.symbol
            @issuer             = token.issuer
            @name               = token.name
            @metadata           = JSON.parse(token.metadata)
            @precision          = token.precision
            @max_supply         = token.maxSupply
            @supply             = token.supply
            @circulating_supply = token.circulatingSupply
            @loki               = token["$loki"]

            return
         end

         ##
         # The tokens current market value
         #
         # @return [SCC::Metric]
         #     the metrics instance
         Contract None => SCC::Metric
         def metric
            if @metric == nil then
               @metric = SCC::Metric.symbol @symbol
            end

            return @metric
         end

         # metric

      private

         metric = nil

         class << self
            ##
            #  Get contract for given symbol
            #
            #  @param [String] name
            #     name of contract
            #  @return [SCC::Contract]
            #     contract found
            #
            Contract String => SCC::Token
            def symbol (name)
               _token = Steem_Engine.contracts_api.find_one(
                  contract: "tokens",
                  table:    "tokens",
                  query:    {
                     "symbol": name
                  })

               return SCC::Token.new _token
            end

            # find

            ##
            #  Get all token
            #
            #  @param [String] name
            #     name of contract
            #  @return [SCC::Contract]
            #     contract found
            #
            Contract String => ArrayOf[SCC::Token]
            def all
               _retval  = []
               _current = 0

               loop do
                  _tokens = Steem_Engine.contracts_api.find(
                     contract:   "tokens",
                     table:      "tokens",
                     query:      Steem_Engine::QUERY_ALL,
                     limit:      Steem_Engine::QUERY_LIMIT,
                     offset:     _current,
                     descending: false)

                  # Exit loop when no result set is returned.
                  #
                  break if (not _tokens) || (_tokens.length == 0)
                  _retval += _tokens.map do |_token|
                     SCC::Token.new _token
                  end

                  # Move current by the actual amount of rows returned
                  #
                  _current = _current + _tokens.length
               end

               return _retval
            end # all
         end # self
   end # Token
end # SCC

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
