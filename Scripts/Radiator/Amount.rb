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

##
# steem-ruby comes with a helpful Radiator::Type::Amount
# class to handle account balances. However
# Radiator::Type::Amount won't let you access any
# attributes which makes using the class quite cumbersome.
#
# This class expands Radiator::Type::Amount to add the
# missing functions making it super convenient.
#
module Radiator
   module Type
      class Amount
         include Contracts::Core
         include Contracts::Builtin

         ##
         # add the missing attribute reader.
         #
         attr_reader :amount, :precision, :asset, :value

         public

            ##
            # Asset string for VESTS
            #
            VESTS = "VESTS"

            ##
            # Asset string for STEEM
            #
            STEEM = "STEEM"

            ##
            # Asset string for Steem Backed Dollar
            #
            SBD = "SBD"

            ##
            # return amount as float to be used for calculations
            #
            # @return [Float]
            #     actual amount as float
            #
            Contract None => Float
            def to_f
               return @amount.to_f
            end

            ##
            # convert VESTS to level or "N/A" when the value
            # isn't a VEST value.
            #
            # @return [String]
            #     one of "Whale", "Orca", "Dolphin", "Minnow", "Plankton" or "N/A"
            #
            Contract None => String
            def to_level
               _value = @amount.to_f

               return (
               if @asset != VESTS then
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
               return (
               case @asset
                  when SBD
                     self.clone
                  when STEEM
                     Amount.to_amount(@amount.to_f * SBD_Median_Price, SBD)
                  when VESTS
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
               return (
               case @asset
                  when SBD
                     Amount.to_amount(@amount.to_f / SBD_Median_Price, STEEM)
                  when STEEM
                     self.clone
                  when VESTS
                     Amount.to_amount(@amount.to_f * Conversion_Rate_Vests, STEEM)
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
               return (
               case @asset
                  when SBD
                     self.to_steem.to_vests
                  when STEEM
                     Amount.to_amount(@amount.to_f / Conversion_Rate_Vests, VESTS)
                  when VESTS
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
               _sbd   = to_sbd
               _steem = to_steem
               _vests = to_vests

               return (
               "%1$15.3f %2$s".colorize(
                  if @asset == SBD then
                     :blue
                  else
                     :white
                  end
               ) + " " + "%3$15.3f %4$s".colorize(
                  if @asset == STEEM then
                     :blue
                  else
                     :white
                  end
               ) + " " + "%5$18.6f %6$s".colorize(
                  if @asset == VESTS then
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
                  _vests.asset]
            end

            ##
            # operator to add two balances
            #
            # @param [Amount]
            #     amount to add
            # @return [Amount]
            #     result of addition
            # @raise [ArgumentError]
            #    values of different asset type
            #
            Contract Amount => Amount
            def +(right)
               raise ArgumentError, 'asset types differ' if @asset != right.asset

               return Amount.to_amount(@amount.to_f + right.to_f, @asset)
            end

            ##
            # operator to subtract two balances
            #
            # @param [Amount]
            #     amount to subtract
            # @return [Amount]
            #     result of subtraction
            # @raise [ArgumentError]
            #    values of different asset type
            #
            Contract Amount => Amount
            def -(right)
               raise ArgumentError, 'asset types differ' if @asset != right.asset

               return Amount.to_amount(@amount.to_f - right.to_f, @asset)
            end

            ##
            # operator to divert two balances
            #
            # @param [Amount]
            #     amount to divert
            # @return [Amount]
            #     result of division
            # @raise [ArgumentError]
            #    values of different asset type
            #
            Contract Amount => Amount
            def *(right)
               raise ArgumentError, 'asset types differ' if @asset != right.asset

               return Amount.to_amount(@amount.to_f * right.to_f, @asset)
            end

            ##
            # operator to divert two balances
            #
            # @param [Amount]
            #     amount to divert
            # @return [Amount]
            #     result of division
            # @raise [ArgumentError]
            #    values of different asset type
            #
            Contract Amount => Amount
            def /(right)
               raise ArgumentError, 'asset types differ' if @asset != right.asset

               return Amount.to_amount(@amount.to_f / right.to_f, @asset)
            end

         class << self
            ##
            # Helper factory method to create a new Amount from
            # an value and asset type.
            #
            # @param [Float] value
            #     the numeric value to create an amount from
            # @param [String] asset
            #     the asset type which should be STEEM, SBD or VESTS
            # @return [Amount]
            #     the value as amount
            Contract Float, String => Amount
            def to_amount(value, asset)
               return Amount.new(value.to_s + " " + asset)
            end
         end
      end # Amount
   end # Type
end # Radiator

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=syntax nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
