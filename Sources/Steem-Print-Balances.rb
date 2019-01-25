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
#  MERCHANTABILITY or ENDIFFTNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see «http://www.gnu.org/licenses/».
############################################################# }}}1 ##########

# use the "steem.rb" file from the radiator gem. This is only needed if you have
# both steem-api and radiator installed.

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'radiator'

$balance                   = 0.0
$savings_balance           = 0.0
$sbd_balance               = 0.0
$savings_sbd_balance       = 0.0
$vesting_shares            = 0.0
$delegated_vesting_shares  = 0.0
$received_vesting_shares   = 0.0
$actual_vesting            = 0.0

##
# steem-ruby comes with a helpful Radiator::Type::Amount class to handle
# account balances. However Radiator::Type::Amount won't let you access any
# attributes which makes the class almost useless.
#
# This class expands Radiator::Type::Amount to add the missing functions
# making it super usefull.
#
class Amount < Radiator::Type::Amount
   ##
   # add the missing attribute reader.
   #
   attr_reader :amount, :precision, :asset, :value

   ##
   # return amount as float to be used for calculations
   #
   def to_f
     return @amount.to_f
   end # to_f

   ##
   # return amount as float to be used for calculations
   #
   def self.to_f(amount)
      new(amount).to_f
   end

   ##
   # operator to add two balacences for the users convinience
   #
   def +(right)
     return @amount.to_f + right.to_f
   end

   ##
   # operator to subtract two balacences for the users convinience
   #
   def -(right)
      retval = if right.is_a?(Numeric) 
         @amount.to_f - right
      else
         @amount.to_f - right.to_f
      end

      return retval
   end
end # Amount

##
# operator to subtract two balacences for the users convinience
#
def Print_Account_Balances (accounts)
   accounts.each do |account|

      # create amount instances for balances

      _balance                   = Amount.new account.balance
      _savings_balance           = Amount.new account.savings_balance
      _sbd_balance               = Amount.new account.sbd_balance
      _savings_sbd_balance       = Amount.new account.savings_sbd_balance
      _vesting_shares            = Amount.new account.vesting_shares
      _delegated_vesting_shares  = Amount.new account.delegated_vesting_shares
      _received_vesting_shares   = Amount.new account.received_vesting_shares
      _actual_vesting            = _vesting_shares - _delegated_vesting_shares + _received_vesting_shares

      puts ("Account: " + account.name).colorize(:blue)
      puts "  Steem           = %1$15.3f %2$s" % [_balance.to_f,                  _balance.asset]
      puts "  Steem Savings   = %1$15.3f %2$s" % [_savings_balance.to_f,          _savings_balance.asset]
      puts "  SBD             = %1$15.3f %2$s" % [_sbd_balance.to_f,              _sbd_balance.asset]
      puts "  SBD Savings     = %1$15.3f %2$s" % [_savings_sbd_balance.to_f,      _savings_sbd_balance.asset]
      puts "  Steem Power     = %1$18.6f %2$s" % [_vesting_shares.to_f,           _vesting_shares.asset]
      puts "  Delegated Steem = %1$18.6f %2$s" % [_delegated_vesting_shares.to_f, _delegated_vesting_shares.asset]
      puts "  Received Steem  = %1$18.6f %2$s" % [_received_vesting_shares.to_f,  _received_vesting_shares.asset]
      puts "  Actual Power    = %1$18.6f VESTS" % _actual_vesting

      $balance                   = _balance                  + $balance                  
      $savings_balance           = _savings_balance          + $savings_balance          
      $sbd_balance               = _sbd_balance              + $sbd_balance              
      $savings_sbd_balance       = _savings_sbd_balance      + $savings_sbd_balance      
      $vesting_shares            = _vesting_shares           + $vesting_shares           
      $delegated_vesting_shares  = _delegated_vesting_shares + $delegated_vesting_shares 
      $received_vesting_shares   = _received_vesting_shares  + $received_vesting_shares  
      $actual_vesting            = _actual_vesting           + $actual_vesting           
   end

   return
end # Print_Account_Balances

if ARGV.length == 0 then
   puts """
Steem-Print-Balances — Print account balances.

Usage:
   Steem-Print-Balances accountname …

"""
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Radiator::DatabaseApi.new

   # request account informations from the Steem database and print out
   # the accounts found using pretty print (pp) or print out error
   # informations when an error occurred.

   Result = Database_Api.get_accounts(Account_Names)

   if Result.key?('error') then
      puts "Error reading accounts:".red
      pp Result.error
   elsif Result.result.length == 0 then
      puts "No accounts found.".yellow
   else
      Print_Account_Balances Result.result
   end
end

puts "All Account: ".blue
puts "  Steem           = %1$15.3f STEEM" % $balance
puts "  Steem Savings   = %1$15.3f STEEM" % $savings_balance
puts "  SBD             = %1$15.3f SBD"   % $sbd_balance
puts "  SBD Savings     = %1$15.3f SBD"   % $savings_sbd_balance
puts "  Steem Power     = %1$18.6f VESTS" % $vesting_shares
puts "  Delegated Steem = %1$18.6f VESTS" % $delegated_vesting_shares
puts "  Received Steem  = %1$18.6f VESTS" % $received_vesting_shares
puts "  Actual Power    = %1$18.6f VESTS" % $actual_vesting

############################################################ {{{1 ###########
# vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab :
# vim: set textwidth=0 filetype=ruby foldmethod=marker nospell :
# vim: spell spelllang=en_gb fileencoding=utf-8 :
