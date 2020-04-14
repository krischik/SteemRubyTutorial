# Using Steem-API with Ruby Part 20 — Access Hive Blockchain 2

ruby hive hive-api steem-api programming tutorials palnet marlians stem neoxian

In this tutorial we will look at using coins and **steem-mechanize** API on the hive blockchain.

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

In this chapter of the tutorial you learn how to write scripts which will run both on the Steem and Hive blockchain using the printing the chain configuration as example.

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
2. The tree APIs can't be used in the same script.

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

In Part 19 we took a first look at accessing the hive blockchain but wqe have not yet used coins and we skipped the **steem-mechanize** API. In this tutorial we will look at both at the example of the Steem-Dump-Vesting and Steem-Print-Vesting. scripts.

When handling amounts it is necessary to know from which chain the amount originates and since the NAI hasn't change and VESTS have the same name all all chain it's necessary to specify the chain from as a separate parameter.

Instead of:

```ruby
   _value = Steem::Type::Amount.new("1000.000000 VEST")
```

you now call:

```ruby
   _value = Steem::Type::Amount.new("1000.000000 VEST", :hive)
```

And that is all there is. The rest happens in the api.

## Implementation using steem-mechanise

The (https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Vesting.rb)[Steem-Dump-Vesting.rb] script is the only script in the tutorial with enough network I/O to warrant using **steem-mechanise**. The script has previously been explained in (https://peakd.com/@krischik/using-steem-api-with-ruby-part-11)[Part 11] so I'm only going to explain the differences needed to make the script Hive compatible.

Initialize access to the steem or hive blockchain. The script will initialize the constant Chain_Options with suitable parameter for the chain selected with the `CHAIN_ID` environment variable.

```ruby
require_relative 'Steem/Chain'
require 'steem-mechanize'
```

Store the chain name for convenience.

```ruby
Chain = Chain_Options[:chain]
```

Maximum retries to be done when an error happens.

```ruby
Max_Retry_Count = if Chain == :hive then
                     5
                  else
                     3
                  end
```

Maximum requests made per second.

Both Steem and Hive will fail if to many requests will be done in a very short time. Hive hasn't got the CPU power yet to accept as many requests per second as Steem does.

```ruby
Request_Per_Second = if Chain == :hive then
                        5.0
                     else
                        20.0
                     end
```


Maximum retries per second made when and error happens.

Hive hasn't got the CPU power yet to accept as many retries per second as Steem does.

```ruby
Retries_Per_Second = if Chain == :hive then
                        0.5
                     else
                        1
                     end
```

After this all `Steem::Type::Amount.new` calls need to be changed to pass the `Chain` constant:

```ruby
      @delegatee           = value.delegatee
      @vesting_shares      = Steem::Type::Amount.new(value.vesting_shares, Chain)
      @min_delegation_time = Time.strptime(value.min_delegation_time + ":Z", "%Y-%m-%dT%H:%M:%S:%Z")
…
   _median_history_price = Condenser_Api.get_current_median_history_price.result
   _base                 = Steem::Type::Amount.new(_median_history_price.base, Chain)
   _quote                = Steem::Type::Amount.new(_median_history_price.quote, Chain)
   SBD_Median_Price      = _base.to_f / _quote.to_f

   _global_properties        = Condenser_Api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Steem::Type::Amount.new(_global_properties.total_vesting_fund_steem, Chain)
   _total_vesting_shares     = Steem::Type::Amount.new(_global_properties.total_vesting_shares, Chain)
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f
```

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Vesting.rb).

The output of the command (for the steem and hive blockchain) looks like this:

```sh
>CHAIN_ID=steem Scripts/Steem-Dump-Vesting.rb krischik
        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |
-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+
    496173 | anthonyadavisii  ⇒ krischik         |           0.804 SBD           5.287 STEEM       10340.898045 VESTS |  2018-01-14 15:52:45 |
   1331721 | krischik         ⇒ digital.mine     |          15.209 SBD         100.058 STEEM      195706.450950 VESTS |  2020-04-03 13:37:15 |
   1331725 | krischik         ⇒ dlike            |          15.209 SBD         100.058 STEEM      195706.373080 VESTS |  2020-04-03 13:47:30 |
   1331723 | krischik         ⇒ project.hope     |         152.088 SBD        1000.577 STEEM     1957063.858825 VESTS |  2020-04-03 13:45:42 |
Finished!

>CHAIN_ID=hive Scripts/Steem-Dump-Vesting.rb krischik
        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |
-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+
    496173 | anthonyadavisii  ⇒ krischik         |           0.869 HBD           5.290  HIVE       10340.898045 VESTS |  2018-01-14 15:52:45 |
   1330473 | krischik         ⇒ digital.mine     |          16.461 HBD         100.159  HIVE      195791.393468 VESTS |  2020-03-24 08:37:24 |
Finished!
```

As is shown the same script work on both chains identical. Only the output is different as I have different delegations on both chains.

## Implementation using radiator

The radiator script is a lot simpler as it only searches for the delegator and not the delegatee. The radiator script has previously been explained in (https://peakd.com/@krischik/using-steem-api-with-ruby-part-10)[Part 10] so I'm only going to explain the differences needed to make the script Hive compatible.


Initialize access to the steem or hive blockchain. The script will initialize the constant Chain_Options with suitable parameter for the chain selected with the `CHAIN_ID` environment variable.

```ruby
require_relative 'Radiator/Chain'
require_relative 'Radiator/Amount'
require_relative 'Radiator/Price'
``

Store the chain name for convenience.

```ruby
Chain = Chain_Options[:chain]
```

Without the need of slowdowns and retries this change is a lot simpler and only the `Radiator::Type::Amount.new` calls need to be changed to pass the `Chain` constant:

```ruby
      @id                  = value.id
      @delegator           = value.delegator
      @delegatee           = value.delegatee
      @vesting_shares      = Radiator::Type::Amount.new(value.vesting_shares, Chain)
      @min_delegation_time = Time.strptime(value.min_delegation_time + ":Z", "%Y-%m-%dT%H:%M:%S:%Z")

…

   _global_properties        = Condenser_Api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Radiator::Type::Amount.new(_global_properties.total_vesting_fund_steem, Chain)
   _total_vesting_shares     = Radiator::Type::Amount.new(_global_properties.total_vesting_shares, Chain)
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

```
**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Vesting.rb).

The output of the command (for the steem blockchain) looks missing the anthonyadavisii delegations:

```sh
>CHAIN_ID=steem Scripts/Steem-Print-Vesting.rb krischik
        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |
-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+
   1331721 | krischik         ⇒ digital.mine     |          15.209 SBD         100.058 STEEM      195706.450950 VESTS |  2020-04-03 13:37:15 | 
   1331725 | krischik         ⇒ dlike            |          15.209 SBD         100.058 STEEM      195706.373080 VESTS |  2020-04-03 13:47:30 | 
   1331723 | krischik         ⇒ project.hope     |         152.088 SBD        1000.579 STEEM     1957063.858825 VESTS |  2020-04-03 13:45:42 | 

>CHAIN_ID=hive Scripts/Steem-Print-Vesting.rb krischik 
        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |
-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+
   1330473 | krischik         ⇒ digital.mine     |          16.460 HBD         100.159  HIVE      195791.393468 VESTS |  2020-03-24 08:37:24 | 
```

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://peakd.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 19](https://peakd.com/@krischik/using-steem-api-with-ruby-part-18)

## Next tutorial

* [Using Steem-API with Ruby Part 21](https://peakd.com/@krischik/using-steem-api-with-ruby-part-20)

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

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
