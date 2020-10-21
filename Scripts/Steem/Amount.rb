#!/opt/local/bin/ruby
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

# use the "steem.rb" file from the steem-ruby gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "steem-ruby", :version=>'1.0.0', :require => "steem"

require 'colorize'
require 'contracts'
require 'steem'

##
# steem-ruby comes with a helpful Steem::Type::Amount class
# to handle account balances. However Steem::Type::Amount
# won't let you access the actual amount as float which is
# quite cumbersome when you want to make calculations.
#
# This class expands Steem::Type::Amount to add the missing
# functions.
#
module Steem
   module Type
      class Amount
	 include Contracts::Core
	 include Contracts::Builtin

	 public

	 ##
	 # convert VESTS to level or "N/A" when the value
	 # isn't a VEST value.
	 #
	 # @return [String]
	 #     one of "Whale", "Orca", "Dolphin", "Minnow", "Plankton" or "N/A"
	 #
	 Contract None => String
	 def to_level
	    _value      = @amount.to_f
	    _chain_info = @@chain_infos[chain]

	    return (
	    if @asset != _chain_info.vest.symbol then
	       "N/A"
	    elsif _value > 1.0e9 then
	       "Whale"
	    elsif _value > 1.0e8 then
	       "Ocra"
	    elsif _value > 1.0e7 then
	       "Dolphin"
	    elsif _value > 1.0e6 then
	       "Minnow"
	    else
	       "Plankton"
	    end)
	 end

	 ##
	 # Convert Amount to steem backed dollar
	 #
	 # @return [Amount]
	 #     the amount represented as steem backed dollar
	 # @raise [ArgumentError]
	 #     not a SBD, STEEM or VESTS value
	 #
	 Contract None => Amount
	 def to_sbd
	    _chain_info = @@chain_infos[chain]

	    return (
	    case @asset
	       when _chain_info.debt.symbol
		  self.clone
	       when _chain_info.core.symbol
		  Amount.to_amount(@amount.to_f * Amount.sbd_median_price(@chain), _chain_info.debt.symbol, @chain)
	       when _chain_info.vest.symbol
		  self.to_steem.to_sbd
	       else
		  raise ArgumentError, 'unknown asset type types'
	    end)
	 end

	 ##
	 # convert Vests to steem
	 #
	 # @return [Amount]
	 #    a value in VESTS value
	 # @raise [ArgumentError]
	 #    not a SBD, STEEM or VESTS value
	 #
	 Contract None => Amount
	 def to_steem
	    _chain_info = @@chain_infos[chain]

	    return (
	    case @asset
	       when _chain_info.debt.symbol
		  Amount.to_amount(@amount.to_f / Amount.sbd_median_price(@chain), _chain_info.core.symbol, @chain)
	       when _chain_info.core.symbol
		  self.clone
	       when _chain_info.vest.symbol
		  Amount.to_amount(@amount.to_f * Amount.conversion_rate_vests(@chain), _chain_info.core.symbol, @chain)
	       else
		  raise ArgumentError, 'unknown asset type types'
	    end)
	 end

	 ##
	 # convert Vests to steem
	 #
	 # @return [Amount]
	 #    a value in VESTS value
	 # @raise [ArgumentError]
	 #    not a SBD, STEEM or VESTS value
	 #
	 Contract None => Amount
	 def to_vests
	    _chain_info = @@chain_infos[chain]

	    return (
	    case @asset
	       when _chain_info.debt.symbol
		  self.to_steem.to_vests
	       when _chain_info.core.symbol
		  Amount.to_amount(@amount.to_f / Amount.conversion_rate_vests(@chain), _chain_info.vest.symbol, @chain)
	       when _chain_info.vest.symbol
		  self.clone
	       else
		  raise ArgumentError, 'unknown asset type types'
	    end)
	 end

	 ##
	 # create a colorized string showing the amount in
	 # SDB, STEEM and VESTS. The actual value is colorized
	 # in blue while the converted values are colorized in
	 # grey (aka dark white).
	 #
	 # @return [String]
	 #    formatted value
	 #
	 Contract None => String
	 def to_ansi_s
	    _chain_info = @@chain_infos[chain]
	    _sbd        = to_sbd
	    _steem      = to_steem
	    _vests      = to_vests

	    return(
	       (
	       "%1$15.3f %2$3s".colorize(
		  if @asset == _chain_info.debt.symbol then
		     :blue
		  else
		     :white
		  end
	       ) + " %3$15.3f %4$5s".colorize(
		  if @asset == _chain_info.core.symbol then
		     :blue
		  else
		     :white
		  end
	       ) + " %5$18.6f %6$5s".colorize(
		  if @asset == _chain_info.vest.symbol then
		     :blue
		  else
		     :white
		  end
	       )) % [
		  _sbd.to_f,
		  _sbd.asset,
		  _steem.to_f,
		  _steem.asset,
		  _vests.to_f,
		  _vests.asset
	       ])
	 end

	 class << self
	    @@condenser_api         = Hash.new
	    @@sbd_median_price      = Hash.new
	    @@conversion_rate_vests = Hash.new

	    ##
	    # create instance to the steem condenser API
	    # which will give us access to to the global
	    # properties and median history.
	    #
	    # @param [Symbol] chain
	    # 	  chain for which to create an api instance
	    # @return [Steem::CondenserApi]
	    #     The condenser API
	    #
	    Contract Symbol => Steem::CondenserApi
	    def condenser_api(chain)
	       unless @@condenser_api.key? chain then
		  @@condenser_api.store(chain, Steem::CondenserApi.new({chain: chain}))
	       end

	       return @@condenser_api[chain]
	    rescue => error
	       Kernel::abort("Error creating condenser API :\n".red + error.to_s)
	    end

	    ##
	    # read the  median history value and Calculate
	    # the conversion Rate for Vests to steem backed
	    # dollar. We use the Amount class from Part 2
	    # to convert the string values into amounts.
	    #
	    # @return [Float]
	    #    Conversion rate Steem ⇔ SBD
	    #
	    Contract Symbol => Num
	    def sbd_median_price(chain)
	       unless @@sbd_median_price.key? chain then
		  _median_history_price = self.condenser_api(chain).get_current_median_history_price.result
		  _base                 = Amount.new(_median_history_price.base, chain)
		  _quote                = Amount.new(_median_history_price.quote, chain)
		  @@sbd_median_price.store(chain, _base.to_f / _quote.to_f)
	       end

	       return @@sbd_median_price[chain]
	    end

	    ##
	    # read the global properties and calculate the
	    # conversion Rate for VESTS to steem. We use
	    # the Amount class from Part 2 to convert the
	    # string values into amounts.
	    #
	    # @return [Float]
	    #    Conversion rate Steem ⇔ VESTS
	    #
	    Contract Symbol => Num

	    def conversion_rate_vests(chain)
	       unless @@conversion_rate_vests.key? chain then
		  _global_properties        = self.condenser_api(chain).get_dynamic_global_properties.result
		  _total_vesting_fund_steem = Amount.new(if chain != :hive then
							    _global_properties.total_vesting_fund_steem
							 else
							    _global_properties.total_vesting_fund_hive
							 end, chain)
		  _total_vesting_shares     = Amount.new(_global_properties.total_vesting_shares, chain)
		  @@conversion_rate_vests.store(chain, _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f)
	       end

	       return @@conversion_rate_vests[chain]
	    end # conversion_rate_vests
	 end # self
      end # Amount
   end # Type
end # Steem

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
