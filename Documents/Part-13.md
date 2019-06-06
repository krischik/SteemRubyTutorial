# Using Steem-API with Ruby Part 13 — Print Data from Steem Engine Database Table

utopian-io tutorials ruby steem-api programming
utopian.pay

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print-SSC-Table-One.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-SSC-Table-One.rb).

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

There are two main components to each contract:

* The contract source code written in Java Script
* A collection of database tables where the contract can store it's data.

In addition to those there is a small set of meta data like the owner and hash code of the contract.

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

Steem Engine allows users to add  token and contacts to the steem block chain. Currently only three predefined contracts are know: _"tokens"_, _"market"_, and "steempegged". Additional contracts can bee added but you have to get into contact with the Steem Engine team.

<center>![img_steem-engine_overview.png](https://cdn.steemitimages.com/DQmQTATEmyZFm8cRspRNYin2CcdYvMRbg2rUe5Cs8ZAGh8s/img_steem-engine_overview.png)</center>

In order to read the content of a table it is necessary to know the name of database tables to query. The [Steem-Print-Print-SSC-Contract.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Print-SSC-Contract.rb) from the [previous part of the tutorial](https://steemit.com/@krischik/using-steem-api-with-ruby-part-11) prints all data of a Steem Engine contract — including the database tables used by the contract.

The table names are found in the aptly named attribute “tables”. Each table name is prefixed with their contract name. Presumably to makes then unique throughout the system. Here a list of the currently known tables names:

| Unique name             | Contact    | Table            |
+-------------------------+------------+------------------|
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

As mentioned only **radiator** offers an API to access Steem Engine. For this **radiator** offerers a name space called `Radiator::SSC`

-----

The first row of any table can be read using the `Contracts.find_one` method which has three mandatory parameters: `contract`, `table` and `query`:

**contract**: The name of the contract. There are currently three known contracts: _"tokens"_, _"market"_, and _"steempegged"_. 
**table**: The name of the tables to query. 
**query**: A list of column names and values. Left empty to query the first row. 

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

   pp _row
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-SSC-Table-One.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-SSC-Table-One.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at XXXXX.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-ScreenshotXXXXX.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 12](https://steemit.com/@krischik/using-steem-api-with-ruby-part-12)

## Next tutorial

* [Using Steem-API with Ruby Part 13](https://steemit.com/@krischik/using-steem-api-with-ruby-part-13)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #14](https://github.com/krischik/SteemRubyTutorial/issues/14)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Engine logo [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![Beneficiary.png](https://cdn.steemitimages.com/DQmYnQfCi8Z12jkaNqADKc37gZ89RKdvdLzp7uXRjbo1AHy/image.png)</center>

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
