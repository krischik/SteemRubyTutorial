# Using Steem-API with Ruby Part 13 — Print Data from Steem Engine Database Table

utopian-io tutorials ruby steem-api programming
utopian.pay

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print-SSC-Table-First.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-SSC-Table-First.rb).

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

<center>![img_train.png](https://cdn.steemitimages.com/DQmSpZxwXGzzVWmAmWHuq4i5Q1vcG7vAPSM8dhqJzq2UmXs/img_train.png)</center>

In this particular chapter you learn how to read a single row from the Steem Engine database tables.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
gem install radiator
```

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

Steem Engine allows users to add  token and contacts to the steem block chain. Currently only three predefined contracts are know: _"tokens"_, _"market"_, and "steempegged". Each contract has one or more database table to store their data.

<center>![img_steem-engine_overview.png](https://cdn.steemitimages.com/DQmQTATEmyZFm8cRspRNYin2CcdYvMRbg2rUe5Cs8ZAGh8s/img_steem-engine_overview.png)</center>

In order to read the content of a table it is necessary to know the name of database tables to query. The [Steem-Print-Print-SSC-Contract.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Print-SSC-Contract.rb) from the [previous part of the tutorial](https://steemit.com/@krischik/using-steem-api-with-ruby-part-11) prints all data of a Steem Engine contract — including the database tables used by the contract.

The table names are found in the aptly named attribute “tables”. Each table name is prefixed with their contract name. Presumably to make them unique throughout the system. Here a list of the currently known tables names:

| Unique name             | Contact    | Table            |
|-------------------------|------------|------------------|
|market_buyBook           |market      |buyBook           |
|market_metrics           |market      |metrics           |
|market_sellBook          |market      |sellBook          |
|market_tradesHistory     |market      |tradesHistory     |
|steempegged_withdrawals  |steempegged |withdrawals       |
|tokens_balances          |tokens      |balances          |
|tokens_contractsBalances |tokens      |contractsBalances |
|tokens_params            |tokens      |params            |
|tokens_pendingUnstakes   |tokens      |pendingUnstakes   |
|tokens_tokens            |tokens      |tokens            |

## Implementation using radiator

As mentioned only **radiator** offers an API to access Steem Engine. For this **radiator** offerers a name space called `Radiator::SSC`. To access the database tables their are two methods: `Contracts.find_one` and `Contracts.find`. The latter will be described in the next part of the tutorial.

Im this part of the tutorial`Contracts.find_one` is used to access the row of any table. The method has three mandatory parameters: `contract`, `table` and `query`:

**contract**: The name of the contract. As mentione there are currently three known contracts: _"tokens"_, _"market"_, and _"steempegged"_.
**table**: The name of the tables to query. See below.
**query**: A list of column names and values. 

-----

In order to just access the first row the query attribute is left empty and the result is just printed. There is no explicit  error message, if the query fails no data is returned.

```ruby
if ARGV.length == 0 then
   puts "
Steem-Print-SSC-Table-Sample — Print first row of a steem engine table.

Usage:
   Steem-Print-SSC-Table-Sample contract_name table_name

"
else
   # read arguments from command line

   _contract = ARGV[0]
   _table = ARGV[1]

   # the query attribute is mandantory, supply an empty query
   # to receive the first row.

   _row = Contracts.find_one(
      contract: _contract,
      table: _table,
      query: {
      }
   )

   if _row == nil then
      puts "No data found, possible reasons:

⑴ The contract does not exist
⑵ The table does not exist
⑶ The table is empty
"
   else
      pp _row
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-SSC-Table-First.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-SSC-Table-First.rb).

The output of the command for the table “tokens” of the contract “tokens” is:

<center>![Screenshot at Jun 06 20-03-31.png](https://cdn.steemitimages.com/DQmdYuAfc8rttHTsSEMnszsNYHGHtvaFZJNdzDyzELYb79K/Screenshot%20at%20Jun%2006%2020-03-31.png)</center>

The output of the command for the table “balances” of the contract “tokens” is:

![Screenshot at Jun 06 20-06-39.png](https://cdn.steemitimages.com/DQmax2zKBNPHcrqbK9NPErXtjHRtzxghnDHwrcgGyYMXPNt/Screenshot%20at%20Jun%2006%2020-06-39.png)

From those output you can learn the names of the columns of the database and both tables will be used to update the  [Steem-Print-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb) script to print the Steem Engine Token in addition to Steem, Steem Dollar and VESTS.

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 12](https://steemit.com/@krischik/using-steem-api-with-ruby-part-12)

## Next tutorial

* [Using Steem-API with Ruby Part 13](https://steemit.com/@krischik/using-steem-api-with-ruby-part-14)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #14](https://github.com/krischik/SteemRubyTutorial/issues/14)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Engine logo [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![Beneficiary.png](https://cdn.steemitimages.com/DQmYnQfCi8Z12jkaNqADKc37gZ89RKdvdLzp7uXRjbo1AHy/image.png)</center>

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png?1) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png?1) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png?1) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png?1) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png?1) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png?1) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png?1)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
