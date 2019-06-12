# Using Steem-API with Ruby Part 2 — Print Account Balances

utopian-io tutorials ruby steem-api programming

![Steemit_Ruby.jpg](https://steemitimages.com/500x270/http://ipfs.busy.org/ipfs/Qmb2hiQCAWohe59NoRHxZXE4X5ok29ZRmNETGHE8qZdwQR)

## Repository
### steem-ruby

* Project Name: Steem Ruby
* Repository: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. When using Ruby you have two APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages I have provided sample code for both APIs so you can decide which is more suitable for you.

In this 2nd part you learn the use of the classes `Steem::Type::Amount` and `Radiator::Type::Amount` and how to handle account balances using them.

## Requirements

You should have basic knowledge of Ruby programming you need to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install steem-ruby
gem install radiator
```

If there is anything not clear you can ask in the comments.

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When you install both APIs you need to tell ruby which one to use.
2. You can't use both APIs in the same script.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

In this second part of the tutorial I demonstrate how to print out account balances from a list of accounts passed on command line. The data will be formatted and a simple calculation is performed to show how you can use arithmetic on account balances.

As mentioned there will be two examples showing the differences. Both `…::Amount` classes have there weaknesses which I compensate by introducing an extended `Amount` class making the rest of the code identical.

You might notice that Steem Power is output in VESTS. In a future part I will show you how to convert VEST value into STEEM value.

## Implementation using steem-ruby

Steem-ruby keeps balance data in low level structures which is rather cumbersome to use. Here an example:

```
  "sbd_balance"=>{"amount"=>"8716549", "precision"=>3, "nai"=>"@@000000013"},
```

The constructor `Steem::Type::Amount` class will parse the structure for you and make the data within more accessible and printable. Let's look in detail how to use `Steem::Type::Amount`:

-----

Make the script executable under Unix. Of course you need to add the correct path to your ruby executable.

```ruby
#!/opt/local/bin/ruby
```

Use the "steem.rb" file from the steem-ruby gem. This is only needed if you have both steem-api and radiator installed.

```ruby
gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
require 'steem'
```

Steem-ruby comes with a helpful `Steem::Type::Amoun` class to handle account balances. However `Steem::Type::Amoun` won't let you access the actual amount as float which is quite cumbersome when you want to make calculations.

This class expands `Steem::Type::Amoun` to add the missing functions.

```ruby
class Amount < Steem::Type::Amount
```

Return amount as float to be used for calculations

```ruby
   def to_f
     return @amount.to_f
   end # to_f
```

Operator to add two balances for the users convenience

```ruby
   def +(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f + right
      else
         @amount.to_f + right.to_f
      end)
   end
```

Operator to subtract two balances for the users convenience

```ruby
   def -(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f - right
      else
         @amount.to_f - right.to_f
      end)
   end
end # Amount
```

Print account information for an array of accounts

```ruby
def print_account_balances (accounts)
   accounts.each do |account|
```

Create an amount instances for each balance to be used for further processing

```ruby
      _balance                   = Amount.new account.balance
      _savings_balance           = Amount.new account.savings_balance
      _sbd_balance               = Amount.new account.sbd_balance
      _savings_sbd_balance       = Amount.new account.savings_sbd_balance
      _vesting_shares            = Amount.new account.vesting_shares
      _delegated_vesting_shares  = Amount.new account.delegated_vesting_shares
      _received_vesting_shares   = Amount.new account.received_vesting_shares
```

Calculate actual vesting by adding and subtracting delegation.

```ruby
      _actual_vesting            = _vesting_shares - (_delegated_vesting_shares + _received_vesting_shares)
```

Pretty print out the balances. Note that for a quick printout Steem::Type::Amount provides a simple to_s method. But this method won't align the decimal point

```ruby
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
```

Read arguments from command line

```ruby
   Account_Names = ARGV
```

Create instance to the steem database API

```ruby
   Database_Api = Steem::DatabaseApi.new
```

Request account information from the Steem database and print out the accounts balances found using a new function or print out error information when an error occurred.

```ruby
   Database_Api.find_accounts(accounts: Account_Names) do |result|
      Accounts = result.accounts

      if Accounts.length == 0 then
         puts "No accounts found.".yellow
      else
```

Print out the actual account balances.

```ruby
         print_account_balances Accounts
      end
   rescue => error
      puts "Error reading accounts:".red
      pp error
   end
end
```
-----

**Hint:** Follow this link on Github for the complete script with syntax highlighting: [Steem-Dump-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Balances.rb).

The output of the command (for the steem account) looks like this:

![Screenshot at Jan 27 17-44-14.png](https://ipfs.busy.org/ipfs/QmS3Cd7342izfri5EXGTcGYTCvNzUEWELASy8z4hFuSMso)

## Steem-Print-Accounts.rb using radiator

Radiator keeps the amount data inside a string which nice for printing but still cumbersome for any further processing:

```
  "sbd_balance"=>"8716.549 SBD",
```

Luckily we don't need to parse the string ourself. The constructor `Radiator::Type::Amount` class will do that for you and provides the same functionality then `Radiator::Type::Amount`.  Let's look in detail how to use `Radiator::Type::Amount`:

-----

Make the script executable under Unix. Of course you need to add the correct path to your ruby executable.

```ruby
#!/opt/local/bin/ruby
```

use the "steem.rb" file from the radiator gem. This is only needed if you have both steem-api and radiator installed.

```ruby
gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'radiator'
```

steem-ruby comes with a helpful `Radiator::Type::Amount` class to handle account balances. However `Radiator::Type::Amount` won't let you access any attributes which makes using the class quite cumbersome.

This class expands `Radiator::Type::Amount` to add the missing functions making it super convenient.

```ruby
class Amount < Radiator::Type::Amount
```

add the missing attribute reader.

```ruby
   attr_reader :amount, :precision, :asset, :value
```

return amount as float to be used for calculations

```ruby
   def to_f
     return @amount.to_f
   end # to_f
```

Operator to add two balances for the users convenience

```ruby
   def +(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f + right
      else
         @amount.to_f + right.to_f
      end)
   end
```

Operator to subtract two balances for the users convenience

```ruby
   def -(right)
      return (if right.is_a?(Numeric) then
         @amount.to_f - right
      else
         @amount.to_f - right.to_f
      end)
   end
end # Amount
```

Print account information for an array of accounts

```ruby
def print_account_balances (accounts)
   accounts.each do |account|
```

Create an amount instances for each balance to be used for further processing

```ruby
      _balance                   = Amount.new account.balance
      _savings_balance           = Amount.new account.savings_balance
      _sbd_balance               = Amount.new account.sbd_balance
      _savings_sbd_balance       = Amount.new account.savings_sbd_balance
      _vesting_shares            = Amount.new account.vesting_shares
      _delegated_vesting_shares  = Amount.new account.delegated_vesting_shares
      _received_vesting_shares   = Amount.new account.received_vesting_shares
```

calculate actual vesting by adding and subtracting delegation.

```ruby
      _actual_vesting            = _vesting_shares - (_delegated_vesting_shares + _received_vesting_shares)
```

Pretty print out the balances. Note that for a quick printout Radiator::Type::Amount provides a simple `to_s` method. But this code will create a nicer output.

```ruby
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
```

Read arguments from command line

```ruby
   Account_Names = ARGV
```

Create instance to the steem database API

```ruby
   Database_Api = Radiator::DatabaseApi.new
```

Request account information from the Steem database and print out the accounts balances found using a new function or print out error information when an error occurred.

```ruby
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
-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem-Print-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

The output of the command (for the steem account) look identical to the previous output:

![Screenshot at Jan 27 17-44-59.png](https://ipfs.busy.org/ipfs/Qma1erQisKUvvKqAPLKFJTuNYGjjRkckzZK1DVgXbQD3AU)

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Next tutorial

* [Using Steem-API with Ruby Part 3](https://steemit.com/@krischik/using-steem-api-with-ruby-part-3)

## Proof of Work

* [SteemRubyTutorial on GitHub](https://github.com/krischik/SteemRubyTutorial)

![image.png](https://ipfs.busy.org/ipfs/Qmb3WV6M4fDUxnnrLjkNXqAV7rd6rh2haRdriYQsbZT1Pr)

<center> ![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png) </center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
