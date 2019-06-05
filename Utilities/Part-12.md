# Using Steem-API with Ruby Part 11 — XXXXX

utopian-io tutorials ruby steem-api programming

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmc3r9KH3ws5oe2feQWtmMmyfNHLcCw4ttp7ppuEk7RB8n/Steemit_Ruby_Engine.png)</center>

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

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain, Steem database and steem engine using Ruby. When accesing steem engine using Ruby their only one  APIs available to chose: **radiator**.

In this particular chapter you learn how to read smart contracts from the steem engine side chain.

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

Steem egnine allows users to add  token and contacts to the steem block chain. Currently only three predefined contracts are know: _"tokens"_, _"market"_, and "steempegged". Additional contracts can bee added but you have to get into contact with the steem engine team.

img_steem-engine_overview.png

## Implementation using radiator

As mentioned only **radiator** offers an API to access steem engine. For this **radiator** offeres a name space called `Radiator::SSC`

-----

The implementation is fairly simple. First an instance `Radiator::SSC::Contracts` is created. 

```ruby
begin
   # create an instance to the radiator contracts API which
   # will give us access to steem engine contracts.

   Contracts = Radiator::SSC::Contracts.new

rescue => error
   # I am using Kernel::abort so the code snipped including
   # error handler can be copy pasted into other scripts

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

Then the contract read using the `contract` method which takes a the name of the contract as parameter. As usualy the script allows more then one contract name to passed on the commandline and a loop is added to get the contract of all names passed. 

```ruby
if ARGV.length == 0 then
   puts "
Steem-Print-SSC-Contract — Print steem engine contracts.

Usage:
   Steem-Print-SSC-Contract contract_name …
"
else
   # read arguments from command line

   Names = ARGV

   # Loop over provided contact names and print the steen
   # engine contracts.

   Names.each do |name|
      _contract = Contracts.contract name

      pp _contract
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Print-SSC-Contract.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Print-SSC-Contract.rb).

The output of the command (for the **token** contract) looks identical to the previous output:

<center>![Screenshot at XXXXX.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-ScreenshotXXXXX.png)</center>

The table attribute the end of the output containst the list of tables from the contract which we will need in the next part of the tutorial.

<center>![Screenshot at XXXXX.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-ScreenshotXXXXX.png)</center>

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
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

![Beneficiary.png](https://cdn.steemitimages.com/DQmYnQfCi8Z12jkaNqADKc37gZ89RKdvdLzp7uXRjbo1AHy/image.png)

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
