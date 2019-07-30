# Using Steem-API with Ruby Part 16 — Print Steem Engine Token balances

utopian-io tutorials ruby steem-api programming
utopian.pay

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Balances.rb).

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

### Steem Engine

<center>![steem-engine_logo-horizontal-dark.png](https://cdn.steemitimages.com/DQmcuU8q2NnZjUcj74ChEQDsUBdE4LNc8t9LpucE25TP7Sf/steem-engine_logo-horizontal-dark.png)</center>

* Project Name: Steem Engine
* Home Page: [https://steem-engine.com](https://steem-engine.com)
* Repository: [https://github.com/harpagon210/steem-engine](https://github.com/harpagon210/steem-engine)
* Official Documentation: [https://github.com/harpagon210/sscjs](https://github.com/harpagon210/sscjs) (JavaScript only)
* Official Tutorial: N/A

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain, Steem database and Steem Engine using Ruby. When accessing Steem Engine using Ruby their only one APIs available to chose: **radiator**.

<center>![img_train-dark.png](https://cdn.steemitimages.com/DQmQjPngbfPaKwQ9VEjZcGQPWkFsSXPbvssuPGzuasmDjzA/img_train-dark.png)</center>

In this particular chapter you learn how to access the current steem engine token balances of any users. FF

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
gem install radiator
```

The tutorial build on top of the following previous chapters:

* [Print Steem Engine Token values](Documents/Part-15.md)
* [Print Account Balances improved](Documents/Part-06.md)

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

As in the last tutorial a class is used for the majority of the work.

## Implementation using radiator

-----

A simple standard constructor for the various properties a balance holds:

|                |                                          |
+----------------+------------------------------------------+
|symbol          | ID of token held                         |
|account         | ID of account holding                    |
|balance         | balance held                             |
|stake           | balance staked                           |
|delegated_stake | stake delegated                          |
|received_stake  | stake stake                              |
|pending_unstake | delegated stake to be returned to owner. |
|loki            |                                          |

```ruby
module SCC
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
```

Convert the current balance into steem using the metric class from the last tutorial.

```ruby
         Contract None => Radiator::Type::Amount
         def to_steem
            _steem = if @symbol == "STEEMP" then
               @balance
            else
               @balance * metric.last_price
            end

            return Radiator::Type::Amount.to_amount(
               _steem,
               Radiator::Type::Amount::STEEM)
         end
```

Convert the current balance into steem using the amount class from the print balances tutorial.

```ruby
         Contract None => Radiator::Type::Amount
         def to_sbd
            return to_steem.to_sbd
         end
```

The metrics of the balance as lazy initialized property. The metric is used to convert the balance into Steem.

```ruby
         Contract None => SCC::Metric
         def metric
            if @metric == nil then
               @metric = SCC::Metric.symbol @symbol
            end

            return @metric
         end
```

The token information of the balance also as lazy initialized property. The token informations contain, among other, the display name of the token.

```ruby
         Contract None => SCC::Token
         def token
            if @token == nil then
               @token = SCC::Token.symbol @symbol
            end

            return @token
         end
```

Create a colourised string showing the amount in SDB, STEEM and the steem engine token. The actual value is colourised in blue while the converted values are colourised in grey (aka dark white).

```ruby
         Contract None => String
         def to_ansi_s
            begin
               _steem = self.to_steem
               _sbd   = self.to_sbd

               _retval = (
               "%1$15.3f %2$s".white +
                  " " +
                  "%3$15.3f %4$s".white +
                  " " +
                  "%5$18.6f %6$s".blue) % [
                  _sbd.to_f,
                  _sbd.asset,
                  _steem.to_f,
                  _steem.asset,
                  @balance,
                  @symbol]
            rescue KeyError
               _na = "N/A"

               _retval = (
               "%1$15s %2$s".white +
                  " " +
                  "%3$15s %4$5s".white +
                  " " +
                  "%5$18.6f %6$s".blue) % [
                  _na,
                  _na,
                  _na,
                  _na,
                  @balance,
                  @symbol]
            end

            return _retval
         end
```

Get balances for gives account name using the find function from 

```ruby
         class << self
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
         end # self
   end # Balance
end # SCC
```

The balance class committed to git also has examples for getting the balances for a given token and all balances store. All three methods are very similar so .

-----

Mots of the Steem-Print-Balances.rb has already been described in [Print Account Balances improved](Documents/Part-06.md) and there are only few changes needed to print the steem engine balances as well:

Most of the functionality is not encapsulated in classes which have been explained previously.

```ruby
require_relative 'Radiator/Amount'
require_relative 'Radiator/Price'
require_relative 'SCC/Balance'
require_relative 'SCC/Token'
```

Print the account value without the steem engine token.

```ruby
      puts(("  Account Value (steem)= " + "%1$15.3f %2$s".green) % [
         _account_value.to_f,
         _account_value.asset])
```


```ruby
      _scc_balances = SCC::Balance.account account.name
      _scc_balances.each do |_scc_balance|
         token = _scc_balance.token

         puts("  %1$-20.20s = %2$s" % [token.name, _scc_balance.to_ansi_s])

         begin
            _sbd           = _scc_balance.to_sbd
            _account_value = _account_value + _sbd
         rescue KeyError
            # do nothing.
         end
      end
```

Print the account value with the value of the steem engine token added.

```ruby
      puts(("  Account Value (total)= " + "%1$15.3f %2$s".green) % [
         _account_value.to_f,
         _account_value.asset])
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

The output of the command changes from previous:

<center>![Screenshot at Mar 14 10-58-50.png](https://cdn.steemitimages.com/DQmU7AAEiA9XHChBabWqBzgQrmBstymxv2HDXz4i1HcTsL5/Screenshot%20at%20Mar%2014%2010-58-50.png)</center>

to now containing the Steem Engine Token values:

<center>![Screenshot at XXXXX.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-ScreenshotXXXXX.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 15](https://steemit.com/@krischik/using-steem-api-with-ruby-part-15)

## Next tutorial

* [Using Steem-API with Ruby Part 17](https://steemit.com/@krischik/using-steem-api-with-ruby-part-17)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #18](https://github.com/krischik/SteemRubyTutorial/issues/18)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Engine logo [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![Beneficiary.png](https://cdn.steemitimages.com/DQmYnQfCi8Z12jkaNqADKc37gZ89RKdvdLzp7uXRjbo1AHy/image.png)</center>

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
