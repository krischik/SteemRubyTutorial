# Using Steem-API with Ruby Part 21 — Access Hive Blockchain 3

ruby hive hive-api steem-api programming tutorials palnet marlians stem neoxian

In this tutorial we will look at converting the three different coins on each chain.

<center>![Hive_Steem_Ruby_Engine.png](https://files.peakd.com/file/peakd-hive/krischik/ve2qoADQ-Hive_Steem_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Vesting.rb)
* radiator sample code: [Steem-Print-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Vesting.rb).

### steem-ruby

* Project Name: Steem Ruby (with Hive patches)
* Repository: [https://github.com/krischik/steem-ruby](https://github.com/krischik/steem-ruby)
* Official Documentation: [https://www.rubydoc.info/gems/steem-ruby](https://www.rubydoc.info/gems/steem-ruby)
* Official Tutorial: N/A

### steem-mechanize

* Project Name: Steem Mechanize (with Hive patches)
* Repository: [https://github.com/krischik/steem-mechanize](https://github.com/krischik/steem-mechanize)
* Official Documentation: [https://www.rubydoc.info/gems/steem-mechanize](https://www.rubydoc.info/gems/steem-mechanize)
* Official Tutorial: N/A

### radiator

* Project Name: Radiator (with Hive patches)
* Repository: [https://github.com/krischik/radiator](https://github.com/krischik/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

## What Will I Learn?

This tutorial shows how to interact with the Steem and Hive blockchain as well as the Steem and Hive database using Ruby. When using Ruby you have three APIs available to chose: **steem-api**, **steem-mechaniz** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **steem-mechanize** drop in replacement for steem-api with more performance network I/O
* **radiator** uses classic function return values and provides high level human readable data.

Since all APIs have advantages and disadvantages sample code for both APIs will be provided so the reader ca decide which is more suitable.

In this chapter of the tutorial you learn how to write scripts which will run both on the Steem and Hive blockchain using the VEST to STEEM and HIVE conversion as example.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following standard ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
```

For Hive compatibility you need the hive patched versions of the `steem-ruby` and `radiator` ruby gems. These are not yet available in the standard ruby gem repository and you need to install them from source. For this you change into the directory you keep Git clones and use the following commands:

```sh
git clone "https://github.com/krischik/steem-ruby"

pushd "steem-ruby"
    git checkout feature/Enhancement22
    gem build "steem-ruby.gemspec"
    gem install "steem-ruby"
popd

git clone "https://github.com/krischik/steem-mechanize"

pushd "steem-mechanize"
    git checkout feature/Enhancement22
    gem build "steem-mechanize.gemspec"
    gem install "steem-mechanize"
popd

git clone "https://github.com/krischik/radiator"

pushd "radiator"
    git checkout feature/Enhancement22
    gem build "radiator.gemspec"
    gem install "radiator"
popd
```

If you already checked out the steem-ruby and radiator you will need to update them to the newest version.

**Note:** All APIs steem-ruby, steem-mechanize and radiator provide a file called `steem.rb`. This means that:

1. When more then one APIs is installed ruby must be told which one to use.
2. The three APIs can't be used in the same script.

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

In the previous parts we took a first look at accessing the hive blockchain and an initial view at using coins. In this tutorial we will look a deeper view at the use of the various coins. 

When writing code a for just one chain one often uses the string literals “STEEM”, “SBD” and “VEST”. This of course won't work for code designed to run with multiple chain. 

To support this the Amount class was extended to return the symbol names for three coin types of a Steem style blockchain:

```ruby
   DEBT_ASSET = Steem::Type::Amount.debt_asset Chain
   CORE_ASSET = Steem::Type::Amount.core_asset Chain
   VEST_ASSET = Steem::Type::Amount.vest_asset Chain
```

The actual values are:

<table style="width:100%; border: 2pt solid black; border-collapse:collapse; border-spacing:0">
  <tr style="border: 1pt solid black">
    <th style="border: 1pt solid black; padding: 4pt">Chain</th>
    <th style="border: 1pt solid black; padding: 4pt">Asset</th>
    <th style="border: 1pt solid black; padding: 4pt">String</th>
  </tr>
  <tr style="border: 1pt solid black">
    <td rowspan="3" style="border: 1pt solid black; padding: 4pt">Steem</td>
    <td style="border: 1pt solid black; padding: 4pt">Core</td>
    <td style="border: 1pt solid black; padding: 4pt">"STEEM"</td>
  </tr>
  <tr style="border: 1pt solid black">
    <td></td>
    <td style="border: 1pt solid black; padding: 4pt">Dept</td>
    <td style="border: 1pt solid black; padding: 4pt">"SBD"</td>
  </tr>
  <tr style="border: 1pt solid black">
    <td></td>
    <td style="border: 1pt solid black; padding: 4pt">Vest</td>
    <td style="border: 1pt solid black; padding: 4pt">"VESTS"</td>
  </tr>
  <tr style="border: 1pt solid black">
    <td rowspan="3" style="border: 1pt solid black; padding: 4pt">Hive</td>
    <td style="border: 1pt solid black; padding: 4pt">Core</td>
    <td style="border: 1pt solid black; padding: 4pt">"HIVE"</td>
  </tr>
  <tr style="border: 1pt solid black">
    <td></td>
    <td style="border: 1pt solid black; padding: 4pt">Dept</td>
    <td style="border: 1pt solid black; padding: 4pt">"HBD"</td>
  </tr>
  <tr style="border: 1pt solid black">
    <td></td>
    <td style="border: 1pt solid black; padding: 4pt">Vest</td>
    <td style="border: 1pt solid black; padding: 4pt">"VESTS"</td>
  </tr>
</table>

## Implementation using steem-ruby

The [Steem-From-VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-From-VEST.rb) script was previously described in [Part 4](https://peakd.com/utopian-io/@krischik/using-steem-api-with-ruby-part-4) of the tutorial. Here we only look at the changed needed to make the script multi chain compatible.

Store the chain name and symbols for convenience.

```ruby
Chain      = Chain_Options[:chain]
DEBT_ASSET = Steem::Type::Amount.debt_asset Chain
CORE_ASSET = Steem::Type::Amount.core_asset Chain
VEST_ASSET = Steem::Type::Amount.vest_asset Chain
```

Create instance to the steem condenser API which will give us access to the requested chain

```ruby
   Condenser_Api = Steem::CondenserApi.new Chain_Options
```

Calculate the conversion rate. We use the `Amount` class from Part 2 to convert the sting values into amounts. The chain need to be passed as different chains have different symbols

```ruby
   _total_vesting_fund_steem = Steem::Type::Amount.new(Global_Properties.total_vesting_fund_steem, Chain)
   _total_vesting_shares     = Steem::Type::Amount.new(Global_Properties.total_vesting_shares, Chain)
```

Read the  median history value and Calculate the conversion Rate for Vests to steem backed dollar. We use the Amount class from Part 2 to convert the string values into amounts.

```ruby
   _median_history_price = Steem::Type::Price.get Chain
   SBD_Median_Price      = _median_history_price.to_f
```

Read the reward funds.

```ruby
   _reward_fund = Steem::Type::Reward_Fund.get Chain
```

Print the result using the the correct symbols for the requested chain

```ruby
   puts "%1$18.6f %2$-5s = %3$15.3f %4$-5s,   100%% Upvote: %5$6.3f %6$-3s" % [
	   value,
	   VEST_ASSET,
	   _steem,
	   CORE_ASSET,
	   _max_vote_value,
	   DEBT_ASSET]
```
-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-From-VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-From-VEST.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Apr 30 154031.png](https://files.peakd.com/file/peakd-hive/krischik/ehErK4Vf-Screenshot20at20Apr20302015-40-31.png)</center>

## Implementation using radiator

The [Steem-To-VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-To-VEST.rb) script was previously described in [Part 4](https://peakd.com/utopian-io/@krischik/using-steem-api-with-ruby-part-4) of the tutorial. Here we only look at the changed needed to make the script multi chain compatible.

Store the chain name and symbols for convenience.

```ruby
Chain      = Chain_Options[:chain]
DEBT_ASSET = Radiator::Type::Amount.debt_asset Chain
CORE_ASSET = Radiator::Type::Amount.core_asset Chain
VEST_ASSET = Radiator::Type::Amount.vest_asset Chain
```

Create instance to the steem condenser API which will give us access to the requested chain

```ruby
   Condenser_Api = Radiator::CondenserApi.new Chain_Options
```

Calculate the conversion rate. We use the `Amount` class from Part 2 to convert the sting values into amounts. The chain need to be passed as different chains have different symbols

```ruby
   _total_vesting_fund_steem = Radiator::Type::Amount.new(Global_Properties.total_vesting_fund_steem, Chain)
   _total_vesting_shares     = Radiator::Type::Amount.new(Global_Properties.total_vesting_shares, Chain)
```

Read the  median history value and Calculate the conversion Rate for Vests to steem backed dollar. We use the Amount class from Part 2 to convert the string values into amounts.

```ruby
   _median_history_price = Radiator::Type::Price.get Chain
```

Read the reward funds.

```ruby
   _reward_fund = Radiator::Type::Reward_Fund.get Chain
```

Print the result using the the correct symbols for the requested chain

```ruby
   puts "%1$18.6f %2$-5s = %3$15.3f %4$-5s,   100%% Upvote: %5$6.3f %6$-3s" % [
	   value,
	   CORE_ASSET,
	   _vest,
	   VEST_ASSET,
	   _max_vote_value,
	   DEBT_ASSET]
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-To-VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-To-VEST.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at Apr 30 154229.png](https://files.peakd.com/file/peakd-hive/krischik/U7hWvT6U-Screenshot20at20Apr20302015-42-29.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://peakd.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 20](https://peakd.com/@krischik/using-steem-api-with-ruby-part-20)

## Next tutorial

* [Using Steem-API with Ruby Part 22](https://peakd.com/@krischik/using-steem-api-with-ruby-part-22)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #22](https://github.com/krischik/SteemRubyTutorial/issues/22)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo: [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Hive logo: [Hive Band Assets](https://hive.io/brand), CC BY-SA 4.0.
* Steem Engine logo: [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

-----

<center>![posts5060.png](https://files.steempeak.com/file/steempeak/krischik/JaSBtA1B-posts-50-60.png)![comments5870.png](https://files.steempeak.com/file/steempeak/krischik/3zh0hy1H-comments-58-70.png)![votes6680.png](https://files.steempeak.com/file/steempeak/krischik/VVR0lQ3T-votes-66-80.png)![level9090.png](https://files.steempeak.com/file/steempeak/krischik/K8PLgaRh-level-90-90.png)![payout6680.png](https://files.steempeak.com/file/steempeak/krischik/EKjrC9xN-payout-66-80.png)![commented5870.png](https://files.steempeak.com/file/steempeak/krischik/bMY0fJGX-commented-58-70.png)![voted5060.png](https://files.steempeak.com/file/steempeak/krischik/P5yFKQ8S-voted-50-60.png)</center>

<center>![posts5060.png](https://images.hive.blog/50x60/http://hivebuzz.me/accounts/@krischik/posts.png)![comments5870.png](https://images.hive.blog/58x70/http://hivebuzz.me/accounts/@krischik/comments.png)![upvotes6680.png](https://images.hive.blog/66x80/http://hivebuzz.me/accounts/@krischik/upvotes.png)![level9090.png](https://images.hive.blog/90x90/http://hivebuzz.me/accounts/@krischik/level.png)![payout6680.png](https://images.hive.blog/66x80/http://hivebuzz.me/accounts/@krischik/payout.png)![replies5870.png](https://images.hive.blog/58x70/http://hivebuzz.me/accounts/@krischik/replies.png)![upvoted5060.png](https://images.hive.blog/50x60/http://hivebuzz.me/accounts/@krischik/upvoted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
