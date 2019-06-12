# Using Steem-API with Ruby Part 12 — Print Steem Engine Contracts

utopian-io tutorials ruby steem-api programming
utopian.pay

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print-Print-SSC-Contract.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Print-SSC-Contract.rb).

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

In this particular chapter you learn how to read smart contracts from the Steem Engine side chain.

<center>![img_train.png](https://cdn.steemitimages.com/DQmSpZxwXGzzVWmAmWHuq4i5Q1vcG7vAPSM8dhqJzq2UmXs/img_train.png)</center>

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

Steem Engine allows users to add  token and contacts to the steem block chain. Currently only three predefined contracts are know: _"tokens"_, _"market"_, and "steempegged". Additional contracts can be added but you have to get into contact with the Steem Engine team.

<center>![img_steem-engine_overview.png](https://cdn.steemitimages.com/DQmQTATEmyZFm8cRspRNYin2CcdYvMRbg2rUe5Cs8ZAGh8s/img_steem-engine_overview.png)</center>

There are two main components to each contract:

* The contract source code written in Java Script.
* A collection of database tables where the contract can store its data.

In addition to those there is a small set of meta data like the owner and hash code of the contract.

## Implementation using radiator

As mentioned only **radiator** offers an API to access Steem Engine. For this **radiator** offerers a name space called `Radiator::SSC`

-----

Reading the contract information is fairly simple. First an instance `Radiator::SSC::Contracts` needs to be created.

```ruby
begin
   # create an instance to the radiator contracts API which
   # will give us access to Steem Engine contracts.

   Contracts = Radiator::SSC::Contracts.new

rescue => error
   # I am using Kernel::abort so the code snipped including
   # error handler can be copy pasted into other scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

Then the contract is read using the `contract` method which takes the name of the contract as parameter. As usually the script allows more then one contract name to passed on the command line and a loop is added to get the contract of all names passed.

```ruby
if ARGV.length == 0 then
   puts "
Steem-Print-SSC-Contract — Print Steem Engine contracts.

Usage:
   Steem-Print-SSC-Contract contract_name …
"
else
   # read arguments from command line

   _names = ARGV

   # Loop over provided contact names and print the steen
   # engine contracts.

   _names.each do |_name|

      # read the contract

       _contract = Contracts.contract _name

      # print the contract

      pp _contract
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Print-SSC-Contract.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Print-SSC-Contract.rb).

The output of the command mostly consists of the actual contract written in JavaScript:

<center>![Screenshot at Jun 05 11-21-40.png](https://cdn.steemitimages.com/DQmTUtfxwCmXcgGJkFcexHMrAc19aW55AHQeTFpvhPRBC2E/Screenshot%20at%20Jun%2005%2011-21-40.png)</center>

The 2nd important attribute is the  table attribute the end of the output which contains the list of tables from the contract which we will need in the next part of the tutorial.

<center>![Screenshot at Jun 05 11-22-39.png](https://cdn.steemitimages.com/DQmRW2SvQxBk78r3z2FeDTq2VS29DApmJB3BCWVVBY7Mtk3/Screenshot%20at%20Jun%2005%2011-22-39.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 11](https://steemit.com/@krischik/using-steem-api-with-ruby-part-11)

## Next tutorial

* [Using Steem-API with Ruby Part 13](https://steemit.com/@krischik/using-steem-api-with-ruby-part-13)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #12](https://github.com/krischik/SteemRubyTutorial/issues/12)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Engine logo [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![Beneficiary.png](https://cdn.steemitimages.com/DQmaNHromgD3b8CpUz15zvvNb7X7k9zYqWW6XqESyLCrM1y/image.png)</center>

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png?1) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png?1) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png?1) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png?1) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png?1) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png?1) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png?1)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
