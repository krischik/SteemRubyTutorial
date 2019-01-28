# Using Steem-API with Ruby Part 2
utopian-io tutorials ruby steem-api programming

![Steemit_Ruby.jpg](https://steemitimages.com/500x270/http://ipfs.busy.org/ipfs/Qmb2hiQCAWohe59NoRHxZXE4X5ok29ZRmNETGHE8qZdwQR)

## Repository
### steem-ruby

* Project Name: Steem Ruby
* Repository: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. When using Ruby you have two APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages I have provided sample code for both APIs so you can decide which is more suitable for you.

In this 2nd part you learn the use of the classes `Steem::Type::Amount` and `Radiator::Type::Amount` and how to handle account balaces using them.

## Requirements

You should have basic knowledge of Ruby programming and have an up to date ruby installed on your computer. If there is anything not clear you can ask in the comments.

In order to use the provided sample you need to install at least Ruby 2.5 and the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install steem-ruby
gem install radiator
```

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When you install both APIs you need to tell ruby which one to use.
2. You can't use both APIs in the same script.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

In this second part of the tutorial I demonstrate how to print out account balances from a list of accounts passed on command line. The data will be formatted and a simple calculation is performed to show how you can use arithmetic on account balances.

As mentioned there will be two examples showing the differences. Both `…::Amount` classes have there weaknesses which I compensate by introducing an extended `Amount` class making the rest of the code identical.

## Implementation using steem-ruby

Check out the comments in the sample code for more details. 

Hint: opening  [Steem-Dump-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/feature/Part2/Scripts/Steem-Dump-Balances.rb) will give you a nice display with syntax highlight.

```ruby

# use the "steem.rb" file from the steem-ruby gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
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
class Amount < Steem::Type::Amount
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
end # Amount

##
# print account information for an array of accounts
#
# @param [Array<>] accounts
#     the accounts to print
#
def print_account_balances (accounts)
   accounts.each do |account|
      # create an amount instances for each balance to be
      # used for further processing

      _balance                   = Amount.new account.balance
      _savings_balance           = Amount.new account.savings_balance
      _sbd_balance               = Amount.new account.sbd_balance
      _savings_sbd_balance       = Amount.new account.savings_sbd_balance
      _vesting_shares            = Amount.new account.vesting_shares
      _delegated_vesting_shares  = Amount.new account.delegated_vesting_shares
      _received_vesting_shares   = Amount.new account.received_vesting_shares

      # calculate actual vesting by adding and subtracting delegation.

      _actual_vesting            = _vesting_shares - (_delegated_vesting_shares + _received_vesting_shares)

      # pretty print out the balances. Note that for a quick printout
      # Steem::Type::Amount provides a simple to_s method. But this method
      # won't align the decimal point

      puts ("Account: " + account.name).colorize(:blue)
      puts "  Steem           = %1$15.3f %2$s" % [_balance.to_f,                  _balance.asset]
      puts "  Steem Savings   = %1$15.3f %2$s" % [_savings_balance.to_f,          _savings_balance.asset]
      puts "  SBD             = %1$15.3f %2$s" % [_sbd_balance.to_f,              _sbd_balance.asset]
      puts "  SBD Savings     = %1$15.3f %2$s" % [_savings_sbd_balance.to_f,      _savings_sbd_balance.asset]
      puts "  Steem Power     = %1$18.6f %2$s" % [_vesting_shares.to_f,           _vesting_shares.asset]
      puts "  Delegated Steem = %1$18.6f %2$s" % [_delegated_vesting_shares.to_f, _delegated_vesting_shares.asset]
      puts "  Received Steem  = %1$18.6f %2$s" % [_received_vesting_shares.to_f,  _received_vesting_shares.asset]
      puts "  Actual Power    = %1$18.6f VESTS" % _actual_vesting
   end

   return
end # Print_Account_Balances

if ARGV.length == 0 then
   puts """
Steem-Dump-Balances — Dump account balances.

Usage:
   Steem-Dump-Balances account_name …

"""
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Steem::DatabaseApi.new

   # request account information from the Steem database
   # and print out the accounts balances found using a new
   # function or print out error information when an error
   # occurred.

   Database_Api.find_accounts(accounts: Account_Names) do |result|
      Accounts = result.accounts

      if Accounts.length == 0 then
         puts "No accounts found.".yellow
      else
         # print out the actual account balances.

         print_account_balances Accounts
      end
   rescue => error
      puts "Error reading accounts:".red
      pp error
   end
end
```

The output of the command (for the steem account) looks like this:

![Screenshot at Jan 27 17-44-14.png](https://ipfs.busy.org/ipfs/QmS3Cd7342izfri5EXGTcGYTCvNzUEWELASy8z4hFuSMso)

## Steem-Print-Accounts.rb using radiator

[Steem-Print-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/feature/Part2/Scripts/Steem-Print-Balances.rb)

Check out the comments in the sample code for more details.

Hint: opening  [Steem-Print-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/feature/Part2/Scripts/Steem-Print-Balances.rb) will give you a nice display with syntax highlight.

```ruby
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
# This class expands Radiator::Type::Amount to add the missing functions
# making it super convenient.
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
end # Amount

##
# print account information for an array of accounts
#
# @param [Array<Object>] accounts
#     the accounts to print#
#
def print_account_balances (accounts)
   accounts.each do |account|
      # create an amount instances for each balance to be
      # used for further processing

      _balance                   = Amount.new account.balance
      _savings_balance           = Amount.new account.savings_balance
      _sbd_balance               = Amount.new account.sbd_balance
      _savings_sbd_balance       = Amount.new account.savings_sbd_balance
      _vesting_shares            = Amount.new account.vesting_shares
      _delegated_vesting_shares  = Amount.new account.delegated_vesting_shares
      _received_vesting_shares   = Amount.new account.received_vesting_shares

      # calculate actual vesting by adding and subtracting
      # delegation.

      _actual_vesting            = _vesting_shares - (_delegated_vesting_shares + _received_vesting_shares)

      # pretty print out the balances. Note that for a
      # quick printout Radiator::Type::Amount provides a 
      # simple to_s method. But this method won't align the
      # decimal point

      puts ("Account: " + account.name).colorize(:blue)
      puts "  Steem           = %1$15.3f %2$s" % [_balance.to_f,                  _balance.asset]
      puts "  Steem Savings   = %1$15.3f %2$s" % [_savings_balance.to_f,          _savings_balance.asset]
      puts "  SBD             = %1$15.3f %2$s" % [_sbd_balance.to_f,              _sbd_balance.asset]
      puts "  SBD Savings     = %1$15.3f %2$s" % [_savings_sbd_balance.to_f,      _savings_sbd_balance.asset]
      puts "  Steem Power     = %1$18.6f %2$s" % [_vesting_shares.to_f,           _vesting_shares.asset]
      puts "  Delegated Steem = %1$18.6f %2$s" % [_delegated_vesting_shares.to_f, _delegated_vesting_shares.asset]
      puts "  Received Steem  = %1$18.6f %2$s" % [_received_vesting_shares.to_f,  _received_vesting_shares.asset]
      puts "  Actual Power    = %1$18.6f VESTS" % _actual_vesting
   end

   return
end # Print_Account_Balances

if ARGV.length == 0 then
   puts """
Steem-Print-Balances — Print account balances.

Usage:
   Steem-Print-Balances account_name …

"""
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Radiator::DatabaseApi.new

   # request account information from the Steem database
   # and print out the accounts balances found using a new
   # function or print out error information when an error
   # occurred.

   Result = Database_Api.get_accounts(Account_Names)

   if Result.key?('error') then
      puts "Error reading accounts:".red
      pp Result.error
   elsif Result.result.length == 0 then
      puts "No accounts found.".yellow
   else
      print_account_balances Result.result
   end
end
```

The output of the command (for the steem account) looks like this:

![Screenshot at Jan 27 17-44-59.png](https://ipfs.busy.org/ipfs/Qma1erQisKUvvKqAPLKFJTuNYGjjRkckzZK1DVgXbQD3AU)

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://busy.org/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 1](https://busy.org/@krischik/using-steem-api-with-ruby-part-1)

## Proof of Work

* [SteemRubyTutorial on GitHub](https://github.com/krischik/SteemRubyTutorial)

![image.png](https://ipfs.busy.org/ipfs/Qmb3WV6M4fDUxnnrLjkNXqAV7rd6rh2haRdriYQsbZT1Pr)

<center> ![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png) </center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
