# Using Steem-API with Ruby Part 14 — Query specific rows from a Steem Engine Table

utopian-io tutorials ruby steem-api programming
utopian.pay

<center>![Steemit_Ruby_Engine.jpg](https://cdn.steemitimages.com/DQmRS8uYnM3h7vdZywWSqKqaU8HqZH2TpuH7KC2P2RK3Ncf/Steemit_Ruby_Engine.jpg)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print-SSC-Table-All.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-SSC-Table-All.rb).

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

### Steem Engine

<center>![steem-engine_logo-horizontal-dark.png](https://cdn.steemitimages.com/DQmX4qGaoCAVRSjMC5ZyCwgcQKXqbKM3KqwuBUMH1qLxXFz/steem-engine_logo-horizontal-dark.png)</center>

* Project Name: Steem Engine
* Home Page: [https://steem-engine.com](https://steem-engine.com)
* Repository: [https://github.com/harpagon210/steem-engine](https://github.com/harpagon210/steem-engine)
* Official Documentation: [https://github.com/harpagon210/sscjs](https://github.com/harpagon210/sscjs) (JavaScript only)
* Official Tutorial: N/A

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain, Steem database and Steem Engine using Ruby. When accessing Steem Engine using Ruby their only one APIs available to chose: **radiator**.

<center>![img_train-dark.png](https://cdn.steemitimages.com/DQmQjPngbfPaKwQ9VEjZcGQPWkFsSXPbvssuPGzuasmDjzA/img_train-dark.png)</center>

In this particular chapter you learn how to read a create a query and return all row from the Steem Engine database tables which matches this query.

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

Steem Engine allows users to add tokens and contacts to the steem block chain. Currently three predefined contracts are know: _"tokens"_, _"market"_, and _"steempegged"_. Each contract has one or more database table to store their data. Currently 10 tables are known:

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

As mentioned only **radiator** offers an API to access Steem Engine. For this **radiator** offerers a name space called `Radiator::SSC`. To access the database tables there are two methods: `Contracts.find_one` and `Contracts.find`. The former was described in the previous part of the tutorial.

Im this part of the tutorial `Contracts.find` is used to access a selection of rows of any table. The method has three mandatory parameters: `contract`, `table` and `query` and three optional parameter `limit`, `offset` and `descending`:

| parameter     | description                            |
|---------------|----------------------------------------|
|**contract**   |The name of the contract.               |
|**table**      |The name of the tables to query.        |
|**query**      |A list of column names and values.      |
|**limit**      |maximum amount of rows to be returned.  |
|**offset**     |offset of the first row to be returned. |
|**descending** |set order to ascending or descending.    |

-----

The amount of rows read from database in a single query. If the overall results exceeds this limit then additional queries are made to get the full result set. One thousand seem to be the standard for Steem queries.

```ruby
Query_Limit = 1000
```

Read arguments from command line. There are two options:

* When two parameter are given then print all rows from a database table.
* When more then two parameter are given then print the rows from database which match the criteria given.

```ruby
   _contract = ARGV.shift
   _table = ARGV.shift
   _query = {}

   while ARGV.length >= 2 do
      # the query parameter is a hash table with column
      # names as key and column values as value.
      #
      _query[ARGV.shift] = ARGV.shift
   end
```

Steem Engine uses a simpler but more error prone numeric index to load the rows in batches. It's easier as only a numeric index is used to keep track of the start row. But it will lead to duplicate and missing rows when rows are added or deleted while iterating over the result set.

```ruby
   _current = 0
   loop do
      _rows = Contracts.find(
         contract: _contract,
         table: _table,
         query: _query,
         limit: Query_Limit,
         offset: _current,
         descending: false
      )

      # exit loop when no result set is returned
      #
   break if (not _rows) || (_rows.length == 0)
      pp _rows

      # Move current by the actual amount of rows returned
      #
      _current = _current + _rows.length
   end

   # at the end of the loop _current holds the total amount
   # of rows returned. If nothing was found _current is 0.
   #
   if _current == 0 then
      puts "No data found, possible reasons:".red + "
   ⑴ The contract doesn't exist
   ⑵ The table doesn't exist
   ⑶ The query doesn't match any rows
   ⑷ The table is empty"
   else
      puts "Found %1$d rows".green % _current
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-SSC-Table-All.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-SSC-Table-All.rb).

## A closer look at the results

The [Steem-Print-SSC-Table-All.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-SSC-Table-All.rb) script is a quite powerfull script which allows for a large variety of queries.

### The »params« table

The »params« table only contains a single row with the current price in STEEM for creating a new token which is currently 100 STEEM.

<center>![Screenshot at Jun 11 16-06-21.png](https://cdn.steemitimages.com/DQmV8ww1K9RZ4ZhjudRoNFzGXNNgu9s3i9LEUai1Uj5n2sa/Screenshot%20at%20Jun%2011%2016-06-21.png)</center>

### The »tokens« table

The »tokens« table contains the parameters of Steem Engine Token like the token distributed and maximum amount of token which can be distributed.

<center>![Screenshot at Jun 12 09-49-02.png](https://cdn.steemitimages.com/DQmPJJ95Kb45wgJ7g83tD9NwfQJW4Aa9F9eULn51Fn6gsTi/Screenshot%20at%20Jun%2012%2009-49-02.png)</center>

I have chosen the BEER token from @beerlover as it's the only token I hold.

<center>![beertoken%20by%20beerlover.png](https://steemitimages.com/0x0/https://cdn.steemitimages.com/DQmY5cLULnVCSrQ5f8x6FaK5RL4CsGqtuCbGG1WZrW2fY9J/beertoken%20by%20beerlover.png)</center>

### The »balances« table

The »balances« table holds the current token in the users wallets. The balances can be queried by account and by token. 

#### query balances by account name

To get all balances of an account you you query by column name `account`.

<center>![Screenshot at Jun 12 10-12-35.png](https://cdn.steemitimages.com/DQmf7z578zzzUxxSmUQcn1AibsAhSJEt71Q3Mswefp2uJ2q/Screenshot%20at%20Jun%2012%2010-12-35.png)</center>

#### query balances by token

To get all balances of an account you query by column name `symbol`. For the sample query is further restricted by current balance of 10 token.

<center>![Screenshot at Jun 12 10-09-20.png](https://cdn.steemitimages.com/DQmeevsJAxhStZmYQQupuedvK7NPkVS85toEE2e2i8K92pA/Screenshot%20at%20Jun%2012%2010-09-20.png)</center>

### The »metrics« table

The »metrics« table holds the current value in STEEM of the token on the [Steem Engine Market](https://steem-engine.com/?p=market&t=BEER).

<center>![Screenshot at Jun 12 10-14-37.png](https://cdn.steemitimages.com/DQmXPQhdpA92fu9fHcWh1qMTNgoKYSo2YdTQnxBGS5zxxWr/Screenshot%20at%20Jun%2012%2010-14-37.png)</center> 

<center>![Steem Engine Market.png](https://cdn.steemitimages.com/DQmXLWT21hjP2zxx2k2fVzYDr26Sz22wPTTk1tQHGHu2ybc/image.png)</center>

A future tutorial will show how to combine all these information to further improve [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb) so that Steem Engine token held are be printed as well.

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 13](https://steemit.com/@krischik/using-steem-api-with-ruby-part-13)

## Next tutorial

* [Using Steem-API with Ruby Part 15](https://steemit.com/@krischik/using-steem-api-with-ruby-part-15)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #15](https://github.com/krischik/SteemRubyTutorial/issues/15)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Engine logo [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![](https://cdn.steemitimages.com/DQmZUkBZYkN7SxDRuchh3D17NwLkenVx2Jg8rBsPqLu28No/image.png)</center>

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png?2) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png?2) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png?2) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png?2) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png?2) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png?2) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png?2)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
