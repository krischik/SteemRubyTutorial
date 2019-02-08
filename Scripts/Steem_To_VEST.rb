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
class Amount < Radiator::Type::Amount
   ##
   # add the missing attribute reader.
   #
   attr_reader :amount, :precision, :asset, :value

   ##
   # return amount as float to be used for calculations
   #
   # @return [Float]
   #     actual amount as float
   #
   def to_f
     return @amount.to_f
   end # to_f

   ##
   # operator to add two balances for the users convenience
   #
   # @param [Numeric|Amount]
   #     amount to add
   # @return [Float]
   #     result of addition
   #
   def +(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f + right
      else
         @amount.to_f + right.to_f
      end)
   end

   ##
   # operator to subtract two balances for the users
   # convenience
   #
   # @param [Numeric|Amount]
   #     amount to subtract
   # @return [Float]
   #     result of subtraction
   #
   def -(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f - right
      else
         @amount.to_f - right.to_f
      end)
   end

   ##
   # operator to divert two balances for the users
   # convenience
   #
   # @param [Numeric|Amount]
   #     amount to divert
   # @return [Float]
   #     result of division
   #
   def /(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f / right
      else
         @amount.to_f / right.to_f
      end)
   end
end # Amount

begin
   # create instance to the steem condenser API which
   # will give us access to

   Condenser_Api = Radiator::CondenserApi.new

   # read the global properties. Yes, it's as simple as
   # this. Note the use of result at the end.

   Global_Properties = Condenser_Api.get_dynamic_global_properties.result
rescue => error
   # I am using Kernel::abort so the code snipped
   # including error handler can be copy pasted into other
   # scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end

# shows usage help if the no values are given to convert.

if ARGV.length == 0 then
   puts """
Steem_To_VEST — Print convert list of Steem value to VESTS values

Usage:
   Steem-Print-Balances values …

"""
else
   # read arguments from command line

   Values = ARGV

   # Calculate the conversion Rate. We use the Amount class
   # from Part 2 to convert the sting values into amounts.

   _total_vesting_fund_steem = Amount.new Global_Properties.total_vesting_fund_steem
   _total_vesting_shares     = Amount.new Global_Properties.total_vesting_shares
   _conversion_rate          = _total_vesting_fund_steem / _total_vesting_shares

   # iterate over the valued passed in the command line

   Values.each do |value|

      # convert the value to steem by dividing with the
      # conversion rate and display the value

      _vest = value.to_f / _conversion_rate
      puts "%1$15.3f STEEM = %2$18.6f VEST" % [value, _vest]
   end
end

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: set spell spelllang=en_gb fileencoding=utf-8 :
