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
   class Balance < SCC::Steem_Engine
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :key, :value,
         :symbol, 
         :account, 
         :balance, 
         :stake, 
         :delegatedStake, 
         :receivedStake, 
         :pendingUnstake, 
         :loki

      public

         ##
         # create instance form Steem Engine JSON object.
         #
         # @param [Hash]
         #    JSON object from contract API.
         #    
         Contract Any => nil
         def initialize(balance)
            super(:symbol, balance.symbol)

            @symbol              = balance.symbol
            @account             = balance.account
            @balance             = balance.balance.to_f
            @stake               = balance.stake.to_f
            @delegatedStake      = balance.delegatedStake.to_f
            @receivedStake       = balance.receivedStake.to_f
            @pendingUnstake      = balance.pendingUnstake.to_f
            @loki                = balance["$loki"]

            return
         end

      class << self
         ##
         #
         #  @param [String] name
         #     name of contract
         #  @return [Array<SCC::Balance>]
         #     contract found
         #
         Contract String => ArrayOf[SCC::Balance]
         def account (name)
            _retval = []
            _current = 0
            _query = {
               "account": name
            }

            loop do
               _balances = Steem_Engine.contracts_api.find(
                  contract: "tokens",
                  table: "balances",
                  query: _query,
                  limit: Steem_Engine.Query_Limit,
                  offset: _current,
                  descending: false)

               # Exit loop when no result set is returned.
               #
            break if (not _balances) || (_balances.length == 0)
               _retval += _balances.map do |_balance|
                  SCC::Balance.new _balance
               end

               # Move current by the actual amount of rows returned
               #
               _current = _current + _balances.length
            end

            return _retval
         end # account

         ##
         #
         #  @param [String] name
         #     name of contract
         #  @return [Array<SCC::Balance>]
         #     contract found
         #
         Contract String => ArrayOf[SCC::Balance]
         def symbol (name)
            _retval = []
            _current = 0
            _query = {
               "symbol": name
            }

            loop do
               _balances = Steem_Engine.contracts_api.find(
                  contract: "tokens",
                  table: "balances",
                  query: _query,
                  limit: Steem_Engine.Query_Limit,
                  offset: _current,
                  descending: false)

               # Exit loop when no result set is returned.
               #
            break if (not _balances) || (_balances.length == 0)
               _retval += _balances.map do |_balance|
                  SCC::Balance.new _balance
               end

               # Move current by the actual amount of rows returned
               #
               _current = _current + _balances.length
            end

            return _retval
         end # symbol
      end # self
   end # Balance
end # SCC

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
