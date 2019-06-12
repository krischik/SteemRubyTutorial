# Using Steem-API with Ruby Part 6 — Print Account Balances improved

utopian-io tutorials ruby steem-api programming

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories
### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb)
* radiator sample code: [Steem-Print.Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Balances.rb).

### steem-ruby

* Project Name: Steem Ruby
* Repository: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)
* Official Documentation: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)
* Official Tutorial: N/A

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. When using Ruby you have two APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages sample code for both APIs will be provided so the reader ca decide which is more suitable.

In this part of the tutorial the `Steem-Dump-Balances.rb` and `Steem-Print-Balances.rb` will be revised to convert all values into each other and calculate the account value.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
gem install steem-ruby
gem install radiator
```

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When both APIs are installed ruby must be told which one to use.
2. Both APIs can't be used in the same script.

This part of the tutorial builds on several previous parts:

* [Using Steem-API with Ruby Part 2 — Print Account Balances](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2)
* [Using Steem-API with Ruby Part 3 — Print Dynamic Global Properties](https://steemit.com/@krischik/using-steem-api-with-ruby-part-3)
* [Using Steem-API with Ruby Part 4 — Convert VESTS ⇔ Steem](https://steemit.com/@krischik/using-steem-api-with-ruby-part-4)
* [Using Steem-API with Ruby Part 5 — Print Current Median History Price](https://steemit.com/@krischik/using-steem-api-with-ruby-part-5)

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

In [Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2) of the tutorial the account balances where printed out the following way:

<center>![Screenshot at Jan 27 17-44-59.png](https://ipfs.busy.org/ipfs/Qma1erQisKUvvKqAPLKFJTuNYGjjRkckzZK1DVgXbQD3AU)</center>

However the values where not the way they are usually displayed on the website:

<center>![Screenshot at Feb 04 142910.png](https://files.steempeak.com/file/steempeak/krischik/wacyfyC6-Screenshot20at20Feb20042014-29-10.png)</center>

The steem power is printed in VESTS which are incredibly large number and the estimated account was missing from the output.

In this part of the tutorial the `Steem-Dump-Balances.rb` and `Steem-Print-Balances.rb` will be improve the output to the user more informations. For this a greatly improved `Amount` class will be used. All the theoretical knowledge has been part of previous tutorials so this tutorial will delve right into the code.

## Implementation using steem-ruby

The central part of the improved script is the improved `Amount` class which can be used in other projects as well.

-----

```ruby
class Amount < Steem::Type::Amount
   include Contracts::Core

   public
```

Defining constants for the three currencies / tokens on on the Steem blockchain. This reduces the risk of typing mistakes.

```ruby
      VESTS = "VESTS"
      STEEM = "STEEM"
      SBD = "SBD"
```

Return the actual amount as float to be used by the various calculations.

```ruby
      Contract nil => Float
      def to_f
         return @amount.to_f
      end
```

Convert VESTS to level, which is one of _"Whale"_, _"Orca"_, _"Dolphin"_, _"Minnow"_, _"Plankton"_ or _"N/A"_ when the value isn't a VEST value.

<table>
  <thead>
    <tr>
      <th>Logo</th>
      <th>Level</th>
      <th>Your Steem Power in VESTS</th>
      <th>Your Steem Power in Steem</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><img src="https://steemitimages.com/50x50/https://files.steempeak.com/file/steempeak/krischik/AnEJ7qNO-level-5.png"></td>
      <td>Whale</td>
      <td>more than 10⁹ VESTS</td>
      <td>more than ≈500'000 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/50x50/https://files.steempeak.com/file/steempeak/krischik/S524LYrT-level-4.png"></td>
      <td>Ocra</td>
      <td>[10⁸ … 10⁹) VESTS</td>
      <td>≈50'000 … ≈500'000 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/50x50/https://files.steempeak.com/file/steempeak/krischik/PiSDad7z-level-3.png"></td>
      <td>Dolphin</td>
      <td>[10⁷ … 10⁸) VESTS</td>
      <td>≈5'000 … ≈50'000 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/50x50/https://files.steempeak.com/file/steempeak/krischik/qPcjmq8w-level-2.png"></td>
      <td>Minnow</td>
      <td>[10⁶ … 10⁷) VESTS</td>
      <td>≈500 … ≈5'000 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/50x50/https://files.steempeak.com/file/steempeak/krischik/3VLfwgNG-level-1.png"></td>
      <td>Plankton</td>
      <td>[0 … 10⁶) VESTS</td>
      <td>0 … ≈500 Steem</td>
    </tr>
  </tbody>
</table>

```ruby
      Contract nil => String
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
```

Converting the amount to a desired asset type. If the amount is already in the needed asset type the value is cloned. Since we only have conversions for VESTS⇔STEEM and STEEM⇔SBD the conversion between VESTS⇔SBD are done in two steps with one recursive call.

```ruby
      Contract nil => Amount
      def to_sbd
         return (
         case @asset
            when SBD
               self.clone
            when STEEM
               Amount.to_amount(@amount.to_f * Conversion_Rate_Steem, SBD)
            when VESTS
               self.to_steem.to_sbd
            else
               raise ArgumentError, 'unknown asset type types'
         end)
      end

      Contract nil => Amount
      def to_steem
         return (
         case @asset
            when SBD
               Amount.to_amount(@amount.to_f / Conversion_Rate_Steem, STEEM)
            when STEEM
               self.clone
            when VESTS
               Amount.to_amount(@amount.to_f * Conversion_Rate_Vests, STEEM)
            else
               raise ArgumentError, 'unknown asset type types'
         end)
      end

      Contract nil => Amount
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
```

Create a colorised string showing the amount in SDB, STEEM and VESTS. The value of the actual asset type is colorised in blue while the converted values are colorised in grey (aka dark white). Here an example:

<center>![to_ansi_s.png](https://files.steempeak.com/file/steempeak/krischik/L8s0kvyr-to_ansi_s.png)</center>

The magic all happens in the `%` operator which calls `sprintf` to create the formatted string.

```ruby
      Contract nil => String
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
```

The arithmetic operators have changed slightly since [Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2).

1. There is now an operator method for all four base functions.
2. Both amounts are checked that if they have the same asset type (which is mathematically correct).
3. A new `Amount` is returned with is of the same asset type (which also is mathematically correct).

In addition to being mathematically correct this makes the methods more simple.

```ruby
      Contract Amount => Amount
      def +(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f + right.to_f, @asset)
      end

      Contract Amount => Amount
      def -(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f - right.to_f, @asset)
      end

      Contract Amount => Amount
      def *(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f * right.to_f, @asset)
      end

      Contract Amount => Amount
      def /(right)
         raise ArgumentError, 'asset types differ' if @asset != right.asset

         return Amount.to_amount(@amount.to_f / right.to_f, @asset)
      end
```

Helper factory method to create a new Amount from an value and asset type. Used by the arithmetic operators amd made private as it's not needed outside the class.

```ruby
   private

      Contract Float, String => Amount
      def self.to_amount(value, asset)
         return Amount.new(value.to_s + " " + asset)
      end
end
```

-----

Since the implementations for steem-api and radiator are almost identical The rest of the functionality is explained in the radiator part.

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Balances.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 13 145331.png](https://files.steempeak.com/file/steempeak/krischik/bj5gfctG-Screenshot20at20Feb20132014-53-31.png)</center>

## Implementation using radiator

First the two conversion for converting VESTS⇔STEEM and STEEM⇔SBD values need to be calculate. This is done using the global properties and the median history.

```ruby
begin
```

Create instance to the steem condenser API which will give us access to to the global properties and the median history.

```ruby
   _condenser_api = Radiator::CondenserApi.new
```

Read the global properties and median history values. Note the use of `result` at the end. It stripps some additional JSON boilerplate which isn't needed and makes the data more useable.

```ruby
   _global_properties    = _condenser_api.get_dynamic_global_properties.result
   _median_history_price = _condenser_api.get_current_median_history_price.result
```

Calculate the conversion Rate for STEEM to SBD. Uses the Amount class to convert the string values into amounts.

```ruby
   _base                 = Amount.new _median_history_price.base
   _quote                = Amount.new _median_history_price.quote
   Conversion_Rate_Steem = _base.to_f / _quote.to_f
```

Calculate the conversion Rate for VESTS to STEEM. Here too the Amount class is used to convert the string values into amounts.

```ruby
   _total_vesting_fund_steem = Amount.new _global_properties.total_vesting_fund_steem
   _total_vesting_shares     = Amount.new _global_properties.total_vesting_shares
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f
rescue => error
```

The Kernel::abort is used so the script aborts when an the important conversion values could not be calculated.

```ruby
   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

Print account information for an array of accounts.

```ruby
def print_account_balances(accounts)
   accounts.each do |account|
```

Create an amount instances for each balance to be used for further processing.

```ruby
      _balance                  = Amount.new account.balance
      _savings_balance          = Amount.new account.savings_balance
      _sbd_balance              = Amount.new account.sbd_balance
      _savings_sbd_balance      = Amount.new account.savings_sbd_balance
      _vesting_shares           = Amount.new account.vesting_shares
      _delegated_vesting_shares = Amount.new account.delegated_vesting_shares
      _received_vesting_shares  = Amount.new account.received_vesting_shares
```

Calculate actual vesting by subtracting and adding delegation done by the user (`_delegated_vesting_shares`) and done to the user (`_received_vesting_shares`).

```ruby
      _actual_vesting = _vesting_shares - _delegated_vesting_shares + _received_vesting_shares
```

Calculate the account value by adding all balances in SBD. Apart from the delegation. Delegation does not add or subtract from the account value as it can be reverted at any time.

```ruby
      _account_value =
         _balance.to_sbd +
            _savings_balance.to_sbd +
            _sbd_balance.to_sbd +
            _savings_sbd_balance.to_sbd +
            _vesting_shares.to_sbd
```

Pretty print out the balances. Note that for a quick printout `Radiator::Type::Amount` provides a simple `to_s` method. But this method won't align the decimal point resulting in a hard to read output. The new `to_ansi_s` will format the values perfectly in columns.

```ruby
      puts ("Account: %1$s".blue + +" " + "(%2$s)".green) % [account.name, _vesting_shares.to_level]
      puts ("  SBD             = " + _sbd_balance.to_ansi_s)
      puts ("  SBD Savings     = " + _savings_sbd_balance.to_ansi_s)
      puts ("  Steem           = " + _balance.to_ansi_s)
      puts ("  Steem Savings   = " + _savings_balance.to_ansi_s)
      puts ("  Steem Power     = " + _vesting_shares.to_ansi_s)
      puts ("  Delegated Power = " + _delegated_vesting_shares.to_ansi_s)
      puts ("  Received Power  = " + _received_vesting_shares.to_ansi_s)
      puts ("  Actual Power    = " + _actual_vesting.to_ansi_s)
      puts ("  Account Value   = " + "%1$15.3f %2$s".green) % [
         _account_value.to_f,
         _account_value.asset]
   end

   return
end

if ARGV.length == 0 then
   puts "
Steem-Print-Balances — Print account balances.

Usage:
   Steem-Print-Balances account_name …

"
else
   Account_Names = ARGV

   Database_Api = Radiator::DatabaseApi.new
```

Request account information from the Steem database and print out the accounts balances found using a new function or print out error information when an error occurred.

```ruby
   Result = Database_Api.get_accounts(Account_Names)

   if Result.key?('error') then
      Kernel::abort("Error reading accounts:\n".red + Result.error.to_s)
   elsif Result.result.length == 0 then
      puts "No accounts found.".yellow
   else
      print_account_balances Result.result
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at Feb 13 145420.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-Screenshot20at20Feb20132014-54-20.png)</center>

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 5](https://steemit.com/@krischik/using-steem-api-with-ruby-part-5)

## Next tutorial

* [Using Steem-API with Ruby Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #7](https://github.com/krischik/SteemRubyTutorial/issues/7)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Power logos: [SteemitBoard](http://steemitboard.com), @captaink
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

![Beneficiary.png](https://cdn.steemitimages.com/DQmYnQfCi8Z12jkaNqADKc37gZ89RKdvdLzp7uXRjbo1AHy/image.png)

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
