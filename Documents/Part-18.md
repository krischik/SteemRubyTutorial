# Using Steem-API with Ruby Part 18 — Print Stacked Steem Token

utopian-io tutorials ruby steem-api programming palnet neoxian marlians stem
utopian.pay

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

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

This tutorial shows how to interact with the Steem blockchain, Steem database and Steem Engine using Ruby. When accessing Steem Engine using Ruby their only the radiator APIs available.

<center>![img_train-dark.png](https://cdn.steemitimages.com/DQmQjPngbfPaKwQ9VEjZcGQPWkFsSXPbvssuPGzuasmDjzA/img_train-dark.png)</center>

In this particular chapter you learn how extend [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb) from the [Print Account Balances improved](Documents/Part-06.md) tutorial so it prints the steem engine token as well.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
gem install radiator
```

The tutorial build on top of the following previous chapters:

* [Print Steem Engine Token values](https://steemit.com/@krischik/using-steem-api-with-ruby-part-15)
* [Print Account Balances improved](https://steemit.com/@krischik/using-steem-api-with-ruby-part-06)
* [Print Steem Engine Token balances](https://steemit.com/@krischik/using-steem-api-with-ruby-part-16)

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

The stacked tokens are stored alongside the non stacked token inside the `balances` table. Of course not all token are staked so you should check if the `token` is `stakingEnabled`.

## Implementation using radiator

### [SCC::Balance](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/SCC/Balance.rb)

Take the staked token into account when calculating steem value of the account's balance.

```ruby
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
```

Add the staked token to the formatted printout.

```ruby
         Contract None => String
         def to_ansi_s
            _na = "N/A"

            begin
               _steem  = self.to_steem
               _sbd    = self.to_sbd
               _staked = self.token.staking_enabled

               _retval = if _staked then
                  ("%1$15.3f %2$s".white +
                     " %3$15.3f %4$s".white +
                     " %5$18.5f %7$-12s".blue +
                     " %6$18.6f %7$-12s".blue) % [
                     _sbd.to_f,
                     _sbd.asset,
                     _steem.to_f,
                     _steem.asset,
                     @balance,
                     @stake,
                     @symbol]
               else
                  ("%1$15.3f %2$s".white +
                     " %3$15.3f %4$s".white +
                     " %5$18.5f %7$-12s".blue +
                     " %6$18s".white) % [
                     _sbd.to_f,
                     _sbd.asset,
                     _steem.to_f,
                     _steem.asset,
                     @balance,
                     _na,
                     @symbol]
               end
            rescue KeyError
               _retval = (
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
                  @symbol]
            end

            return _retval
         end
```

### [SCC::Token](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/SCC/Token.rb)

Add additional attributes describing staked token.

```ruby
      attr_reader :key, :value,
                  :symbol,
                  :issuer,
                  :name,
                  :metadata,
                  :precision,
                  :max_supply,
                  :supply,
                  :circulating_supply,
                  :staking_enabled,
                  :unstaking_cooldown,
                  :delegation_enabled,
                  :undelegation_cooldown,
                  :loki

         Contract Any => nil
         def initialize(token)
            super(:symbol, token.symbol)

            @symbol               = token.symbol
            @issuer               = token.issuer
            @name                 = token.name
            @metadata             = JSON.parse(token.metadata)
            @precision            = token.precision
            @max_supply           = token.maxSupply
            @supply               = token.supply
            @circulating_supply   = token.circulatingSupply
            @stakingEnabled       = token.staking_enabled
            @total_staked          = token.total_staked
            @unstakingCooldown    = token.unstaking_cooldown
            @delegationEnabled    = token.delegation_enabled
            @undelegationCooldown = token.undelegation_cooldown
            @loki                 = token["$loki"]

            return
         end # initialize
```

### [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb)

Update printout and add calculation of accounts steem engine token values.

```ruby
      _scc_balances = SCC::Balance.account account.name
      _scc_value    = Radiator::Type::Amount.new("0.0 SBD")
      _scc_balances.each do |_scc_balance|
         token = _scc_balance.token

         puts("  %1$-22.22s = %2$s" % [token.name, _scc_balance.to_ansi_s])

         # Add token value (in SDB to the account value.
         begin
            _sbd           = _scc_balance.to_sbd
            _scc_value     = _scc_value + _sbd
            _account_value = _account_value + _sbd
         rescue KeyError
            # do nothing.
         end
      end

      puts(("  Account Value (engine) = " + "%1$15.3f %2$s".green) % [
         _scc_value.to_f,
         _scc_value.asset])
      puts(("  Account Value          = " + "%1$15.3f %2$s".green) % [
         _account_value.to_f,
         _account_value.asset])
```

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

-----

The output of the command changes from previous only printing the steem engine token have not been stacked:
<center>![Screenshot at Jul 30 15-23-14.png](https://cdn.steemitimages.com/DQmWdg5GNopbmWUHBuEeaYuGmSc4bPYxR3XFymfMWoxLQ4F/Screenshot%20at%20Jul%2030%2015-23-14.png)</center>
to now printing the values of the staked Steem Engine Token as well:


<center>![Screenshot at XXXXX.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-ScreenshotXXXXX.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 17](https://steemit.com/@krischik/using-steem-api-with-ruby-part-17)

## Next tutorial

* [Using Steem-API with Ruby Part 19](https://steemit.com/@krischik/using-steem-api-with-ruby-part-19)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #20](https://github.com/krischik/SteemRubyTutorial/issues/20)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Engine logo [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

<center>![posts5060.png](https://files.steempeak.com/file/steempeak/krischik/JaSBtA1B-posts-50-60.png)![comments5870.png](https://files.steempeak.com/file/steempeak/krischik/3zh0hy1H-comments-58-70.png)![votes6680.png](https://files.steempeak.com/file/steempeak/krischik/VVR0lQ3T-votes-66-80.png)![level9090.png](https://files.steempeak.com/file/steempeak/krischik/K8PLgaRh-level-90-90.png)![payout6680.png](https://files.steempeak.com/file/steempeak/krischik/EKjrC9xN-payout-66-80.png)![commented5870.png](https://files.steempeak.com/file/steempeak/krischik/bMY0fJGX-commented-58-70.png)![voted5060.png](https://files.steempeak.com/file/steempeak/krischik/P5yFKQ8S-voted-50-60.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
