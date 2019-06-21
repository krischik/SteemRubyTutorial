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

module SCC
   ##
   #
   class Metric < SCC::Steem_Engine
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :key, :value,
         :symbol,
         :volume,
         :volumeExpiration,
         :lastPrice,
         :lowestAsk,
         :highestBid,
         :lastDayPrice,
         :lastDayPriceExpiration,
         :priceChangeSteem,
         :priceChangePercent,
         :loki

      public

         ##
         # create instance form Steem Engine JSON object.
         #
         # @param [Hash]
         #    JSON object from contract API.
         #
         Contract Any => nil
         def initialize(metric)
            super(:symbol, metric.symbol)

            @symbol                    = metric.symbol
            @volume                    = metric.volume.to_f
            @volumeExpiration          = metric.volumeExpiration
            @lastPrice                 = metric.lastPrice.to_f
            @lowestAsk                 = metric.lowestAsk.to_f
            @highestBid                = metric.highestBid.to_f
            @lastDayPrice              = metric.lastPrice.to_f
            @lastDayPriceExpiration    = metric.lastDayPriceExpiration
            @priceChangeSteem          = metric.priceChangeSteem.to_f
            @priceChangePercent        = metric.priceChangePercent
            @loki                      = metric["$loki"]

            return
         end

         ##
         # create a colorized string showing the amount in
         # SDB, STEEM and the steem engine token. The
         # actual value is colorized in blue while the
         # converted values are colorized in grey (aka dark
         # white).
         #
         # @return [String]
         #    formatted value
         #
         Contract None => String
         def to_ansi_s
            begin
               return (
                  "%1$-12s" +
                  " | " +
                  "%2$18.6f STEEM".colorize(
                     if @highestBid > 0.000001 then
                        :green
                     else
                        :white
                     end
                   ) +
                   " | " +
                   "%3$18.6f STEEM".colorize(
                     if @lastPrice > 0.000001 then
                        :blue
                     else
                        :white
                     end
                   ) +
                   " | " +
                   "%4$18.6f STEEM".colorize(
                     if @lowestAsk > 0.000001 then
                        :red
                     else
                        :white
                     end )+
                   " | "
                   ) % [
                     @symbol,
                     @highestBid,
                     @lastPrice,
                     @lowestAsk
                  ]
            end

            return _retval
         end

      class << self
         ##
         #
         #  @param [String] name
         #     name of symbol
         #  @return [Array<SCC::Metric>]
         #     metric found
         #
         Contract String => Or[SCC::Metric, nil]
         def symbol (name)
            _metric = Steem_Engine.contracts_api.find_one(
               contract: "market",
               table: "metrics",
               query: {
                  "symbol": name
               })

            raise KeyError, "Symbol «" + name + "» not found" if _metric == nil

            return SCC::Metric.new _metric
         end # symbol

         ##
         #  Get all token
         #
         #  @return [SCC::Metric]
         #     metric found
         #
         Contract String => ArrayOf[SCC::Metric]
         def all
            _retval = []
            _current = 0

            loop do
               _metric = Steem_Engine.contracts_api.find(
                  contract: "market",
                  table: "metrics",
                  query: Steem_Engine::QUERY_ALL,
                  limit: Steem_Engine::QUERY_LIMIT,
                  offset: _current,
                  descending: false)

               # Exit loop when no result set is returned.
               #
            break if (not _metric) || (_metric.length == 0)
               _retval += _metric.map do |_token|
                  SCC::Metric.new _token
               end

               # Move current by the actual amount of rows returned
               #
               _current = _current + _metric.length
            end

            return _retval
         end # all
      end # self
   end # Metric
end # SCC

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
