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

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'contracts'
require 'radiator'
require 'json'

require_relative 'Steem_Engine'
require_relative 'Metric'
require_relative 'Token'
require_relative '../Radiator/Amount'

module SCC
   ##
   # Holds the balances of Steem Engine Token.
   #
   # @property [String] symbol
   #     ID of token held
   # @property [String] account
   #     ID of account holding
   # @property [Number] balance
   #     balance held
   # @property [Number] stake
   #     balance staked
   # @property [Number] delegated_stake
   #     stake delegated
   # @property [Number] received_stake
   #     stake stake
   # @property [Number] pending_unstake
   #     delegated stake to be returned to owner.
   # @property [String] loki
   #
   class Balance < SCC::Steem_Engine
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :key, :value,
		  :symbol,
		  :account,
		  :balance,
		  :stake,
		  :delegated_Stake,
		  :received_stake,
		  :pending_unstake,
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

	 @symbol          = balance.symbol
	 @account         = balance.account
	 @balance         = balance.balance.to_f
	 @stake           = balance.stake.to_f
	 @delegated_stake = balance.delegatedStake.to_f
	 @received_stake  = balance.receivedStake.to_f
	 @pending_unstake = balance.pendingUnstake.to_f
	 @loki            = balance["$loki"]

	 return
      end

      ##
      # balance in steem.
      #
      # @return [Radiator::Amount]
      #     the current value in steem
      #
      Contract None => Radiator::Type::Amount
      def to_steem
	 _steem = if @symbol == "STEEMP" then
		     @balance
		  elsif token.staking_enabled then
		     (@balance + @stake) * metric.last_price
		  else
		     @balance * metric.last_price
		  end

	 return Radiator::Type::Amount.to_amount(
	    _steem,
	    Radiator::Type::Amount::STEEM)
      end

      ##
      # balance in steem backed dollar.
      #
      # @return [Radiator::Amount]
      #     the current value in steem
      #
      Contract None => Radiator::Type::Amount
      def to_sbd
	 return to_steem.to_sbd
      end

      ##
      # The metrics of the balance as lazy initialized
      # property. The metric is used to convert the
      # balance into Steem.
      #
      # @return [SCC::Metric]
      #     the metrics instance
      #
      Contract None => SCC::Metric
      def metric
	 if @metric == nil then
	    @metric = SCC::Metric.symbol @symbol
	 end

	 return @metric
      end

      ##
      # The token information of the balance also as
      # lazy initialized property. The token
      # informations contain, among other, the display
      # name of the token.
      #
      # @return [SCC::Metric]
      #     the metrics instance
      #
      Contract None => SCC::Token
      def token
	 if @token == nil then
	    @token = SCC::Token.symbol @symbol
	 end

	 return @token
      end

      ##
      # create a colourised string showing the amount in
      # SDB, STEEM and the steem engine token. The
      # actual value is colourised in blue while the
      # converted values are colourised in grey (aka dark
      # white).
      #
      # @return [String]
      #    formatted value
      #
      Contract None => String
      def to_ansi_s
	 _na = "N/A"

	 begin
	    _steem  = self.to_steem
	    _sbd    = self.to_sbd
	    _staked = self.token.staking_enabled
	    _retval = if _staked then
			 (("%1$15.3f %2$s".white +
			    " %3$15.3f %4$s".white +
			    " %5$18.5f %7$-12s".blue +
			    " %6$18.6f %7$-12s".blue) % [
			    _sbd.to_f,
			    _sbd.asset,
			    _steem.to_f,
			    _steem.asset,
			    @balance,
			    @stake,
			    @symbol])
		      else
			 (("%1$15.3f %2$s".white +
			    " %3$15.3f %4$s".white +
			    " %5$18.5f %7$-12s".blue +
			    " %6$18s".white) % [
			    _sbd.to_f,
			    _sbd.asset,
			    _steem.to_f,
			    _steem.asset,
			    @balance,
			    _na,
			    @symbol])
		      end
	 rescue KeyError
	    _retval = ((
	    "%1$15s %2$s".white +
	       " %3$15s %4$5s".white +
	       " %5$18.5f %7$-12s".blue +
	       " %6$18.6f %7$-12s".blue) % [
	       _na,
	       _na,
	       _na,
	       _na,
	       @balance,
	       @stake,
	       @symbol])
	 end

	 return _retval
      end

      class << self
	 ##
	 #  Get balances for gives account name
	 #
	 #  @param [String] name
	 #     name of contract
	 #  @return [Array<SCC::Balance>]
	 #     contract found
	 #
	 Contract String => ArrayOf[SCC::Balance]
	 def account (name)
	    _retval  = []
	    _current = 0
	    _query   = {
	       "account": name
	    }

	    loop do
	       # Read the next batch of balances using
	       # the find function.
	       #
	       _balances = Steem_Engine.contracts_api.find(
		  contract:   "tokens",
		  table:      "balances",
		  query:      _query,
		  limit:      SCC::Steem_Engine::QUERY_LIMIT,
		  offset:     _current,
		  descending: false)

	       # Exit loop when no result set is returned.
	       #
	       break if (not _balances) || (_balances.length == 0)

	       # convert each returned JSON object into
	       # a class instacnce.
	       #
	       _retval += _balances.map do |_balance|
		  SCC::Balance.new _balance
	       end

	       # Move current by the actual amount of rows returned
	       #
	       _current = _current + _balances.length
	    end

	    return _retval
	 end

	 ##
	 #  Get balances for one token
	 #
	 #  @param [String] name
	 #     name of contract
	 #  @return [Array<SCC::Balance>]
	 #     contract found
	 #
	 Contract String => ArrayOf[SCC::Balance]
	 def symbol (name)
	    _retval  = []
	    _current = 0
	    _query   = {
	       "symbol": name
	    }

	    loop do
	       # Read the next batch of balances using
	       # the find function.
	       #
	       _balances = Steem_Engine.contracts_api.find(
		  contract:   "tokens",
		  table:      "balances",
		  query:      _query,
		  limit:      Steem_Engine::QUERY_LIMIT,
		  offset:     _current,
		  descending: false)

	       # Exit loop when no result set is
	       # returned.
	       #
	       break if (not _balances) || (_balances.length == 0)

	       # convert each returned JSON object into
	       # a class instacnce.
	       #
	       _retval += _balances.map do |_balance|
		  SCC::Balance.new _balance
	       end

	       # Move current by the actual amount of
	       # rows returned
	       #
	       _current = _current + _balances.length
	    end

	    return _retval
	 end

	 ##
	 #  Get all balances
	 #
	 #  @return [SCC::Balance]
	 #     token found
	 #
	 Contract String => ArrayOf[SCC::Balance]
	 def all
	    _retval  = []
	    _current = 0

	    loop do
	       # Read the next batch of balances using
	       # the find function.
	       #
	       _balances = Steem_Engine.contracts_api.find(
		  contract:   "tokens",
		  table:      "balances",
		  query:      Steem_Engine::QUERY_ALL,
		  limit:      Steem_Engine::QUERY_LIMIT,
		  offset:     _current,
		  descending: false)

	       # Exit loop when no result set is
	       # returned.
	       #
	       break if (not _balances) || (_balances.length == 0)

	       # convert each returned JSON object into
	       # a class instacnce.
	       #
	       _retval += _balances.map do |_balance|
		  SCC::Balance.new _balance
	       end

	       # Move current by the actual amount of
	       # rows returned
	       #
	       _current = _current + _balances.length
	    end

	    return _retval
	 end # all
      end # self
   end # Balance
end # SCC

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
