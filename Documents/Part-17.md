# Using Steem-API with Ruby Part 17 — Bonus: Unit Testing

utopian-io tutorials ruby steem-api programming palnet neoxian marlians stem
utopian.pay

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-XXXXX.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-XXXXX.rb)
* radiator sample code: [Steem-Print-XXXXX.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-XXXXX.rb).

### steem-ruby

* Project Name: Steem Ruby
* Repository: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)
* Official Documentation: [https://www.rubydoc.info/gems/steem-ruby](https://www.rubydoc.info/gems/steem-ruby)
* Official Tutorial: N/A

### steem-mechanize

* Project Name: Steem Mechanize
* Repository: [https://github.com/steemit/steem-mechanize](https://github.com/steemit/steem-mechanize)
* Official Documentation: [https://www.rubydoc.info/gems/steem-mechanize](https://www.rubydoc.info/gems/steem-mechanize)
* Official Tutorial: N/A

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

This tutorial shows how to write unit tests for Steem blockchain and Steem database using Ruby. When using Ruby you have three APIs available to chose: **steem-api**, **steem-mechanize** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **steem-mechanize** drop in replacement for steem-api with more performat network I/O
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages sample code for both APIs will be provided so the reader ca decide which is more suitable.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install test-unit
gem install bundler
gem install colorize
gem install contracts
gem install steem-ruby
gem install steem-mechanize
gem install radiator
```

**Note:** All APIs steem-ruby, steem-mechanize and radiator provide a file called `steem.rb`. This means that:

1. When more then one APIs is installed ruby must be told which one to use.
2. The tree APIs can't be used in the same script.

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

The various classes in described in this tutorial need trough testing. For this a variety of Test classes where created:

* [Test/Steem_Suite.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Steem_Suite.rb)
    * [Test/Steem\_Amount\_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Steem_Amount_Test.rb)
* [Test/Radiator_Suite.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Radiator_Suite.rb)
    * [Test/Radiator\_Amount\_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Radiator_Amount_Test.rb)
    * [Test/Radiator\_Reward\_Fund_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Radiator_Reward_Fund_Test.rb)
    * [Test/Radiator\_Price\_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Price_Test.rb)
* [Test/SCC_Suite.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/SCC_Suite.rb)
    * [Test/SCC_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/SCC_Test.rb)
    * [Test/SCC\_Contract\_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Contract_Test.rb)
    * [Test/SCC\_Token\_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/SCC_Token_Test.rb)
    * [Test/SCC\_Balance\_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/SCC_Balance_Test.rb)
    * [Test/SCC\_Metric\_Test.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/SCC_Metric_Test.rb)
* [Test/Suite.command](https://github.com/krischik/SteemRubyTutorial/blob/master/Test/Suite.command)

## Implementation using steem-ruby

### Tests

-----

```ruby
```

-----

### Suites

A collection of tests can be grouped to a test suite. All that is needed is to `require` the individual tests.

```ruby
```

### All tests

A test suite can call futher suites to create a hirachy of tests. However,  steem-ruby, steem-mechanize and radiator are incompatibel with each other so at the top level a shell script is used.

```sh
```

**Hint:** Follow this link to Github for the complete scripts with comments and syntax highlighting: [Test/](https://github.com/krischik/SteemRubyTutorial/blob/master/Test).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 13 145331.png](https://files.steempeak.com/file/steempeak/krischik/bj5gfctG-Screenshot20at20Feb20132014-53-31.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part XXXXX](https://steemit.com/@krischik/using-steem-api-with-ruby-part-XXXXX)

## Next tutorial

* [Using Steem-API with Ruby Part XXXXX](https://steemit.com/@krischik/using-steem-api-with-ruby-part-XXXXX)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #XXXXX](https://github.com/krischik/SteemRubyTutorial/issues/XXXXX)

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
