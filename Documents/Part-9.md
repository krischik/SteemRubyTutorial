# Using Steem-API with Ruby Part 9 — Print Posting Votes improved

utopian-io tutorials ruby steem-api programming
utopian.pay

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Posting-Votes.rb)
* radiator sample code: [Steem-Print-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Posting-Votes.rb).

### steem-ruby

* Project Name: Steem Ruby
* Repository: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)
* Official Documentation: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)
* Official Tutorial: N/A

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. When using Ruby you have two APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages sample code for both APIs will be provided so the reader can decide which is more suitable.

This instalment teaches how to calculate the estimated values of all votes on all posting. How we get the lost was already described in [Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7)

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
gem install steem-ruby
gem install radiator
```

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When both APIs are installed ruby must be told which one to use.
2. Both APIs can't be used in the same script.

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

Calculating the vote value is fairly easy as the `rshares` of each vote are calculated when the vote is cast and is then stored. As explained in [Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7) they can be accessed via `get_active_votes` method of the `CondenserApi`:

<center>![Screenshot at Feb 26 16-17-18.png](https://cdn.steemitimages.com/DQmcxuPUSRvRXFj2D4mq5UTDpacnodJzqRFmh1Lk5mXedup/Screenshot%20at%20Feb%2026%2016-17-18.png)</center>

All that is needed is to calculate the estimate with the formula explained in [Part 8](https://steemit.com/@krischik/using-steem-api-with-ruby-part-8):

<center>![estimate = \frac{rshares}{recent\_claims \times reward\_balance \times sbd\_median\_price}](https://cdn.steemitimages.com/DQmQjroDqHAcPmS2zMUPphmMCKwz3FZFD9qB428iyhFKo8e/Estimate.png)</center>

## Implementation using steem-ruby

-----

The `Amount` class is used in most Scripts so it was moved into a separate file. You can find the source code in Git under [Steem/Amount.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem/Amount.rb)

```ruby
require_relative 'Steem/Amount'
```

Create a new class  instance from the data which was returned by the `get_active_votes` method.

```ruby
   Contract HashOf[String => Or[String, Num]] => nil
   def initialize(value)
      super(:vote, value)

      @voter      = value.voter
```

`percent` is a fixed numbers with 4 decimal places and need to be divided by 10000 to make the value mathematically correct and easier to handle. Floats are not as precise as fixed numbers so this is only acceptable because we calculate estimates and not final values.

```ruby
      @percent    = value.percent / 10000.0
```

`weight` is described as weight of the voting power. No further information to be found.

```ruby
      @weight     = value.weight.to_i
```

`rshares` is the rewards share the votes gets from the reward pool.

```ruby
      @rshares    = value.rshares.to_i
```

`reputation` is always 0 — It's probably obsolete and only kept for compatibility.

```ruby
      @reputation = value.reputation
```

Steem is using an unusual date time format which which makes a special scanner necessary. Also it's'  missing the timezone indicator so it's necessary to append a Z.

```ruby
      @time       = Time.strptime(value.time + ":Z" , "%Y-%m-%dT%H:%M:%S:%Z")

      return
   end
```

Calculate the vote estimate from the `rshares` as described.

```ruby
   Contract None => Num
   def estimate
      return @rshares.to_f / Recent_Claims * Reward_Balance.to_f * SBD_Median_Price
   en
```

Create a colourised string from the instance. The vote percentages and estimate and are colourised (positive values are printed in green, negative values in red and zero votes (yes they exist) are shown in grey), for improved human readability.

```ruby
   Contract None => String
   def to_ansi_s
      # multiply percent with 100 for human readability
      _percent = @percent * 100.0
      _estimate = estimate

      # All the magic happens in the `%` operators which
      # calls sprintf which in turn formats the string.
      return (
         "%1$-16s | " +
         "%2$7.2f%%".colorize(
            if _percent > 0.0 then
               :green
            elsif _percent < -0.0 then
               :red
            else
               :white
            end
         ) + 
         " |" + 
         "%3$10.3f SBD".colorize(
            if _estimate > 0.0005 then
               :green
            elsif _estimate < -0.0005 then
               :red
            else
               :white
            end
         ) + 
         " |%4$10d |%5$16d |%6$20s |") % [
            @voter,
            _percent,
            _estimate,
            @weight,
            @rshares,
            @time.strftime("%Y-%m-%d %H:%M:%S")
         ]
   end
```

The method which print the list a vote values from [Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7) has been enhanced to sum up and print the estimates.

```ruby
   Contract ArrayOf[HashOf[String => Or[String, Num]] ] => nil
   def self.print_list (votes)
      # used to calculate the total vote value
      _total_estimate = 0.0

      votes.each do |_vote|
         _vote = Vote.new _vote

         puts _vote.to_ansi_s

         # add up estimate
         _total_estimate = _total_estimate + _vote.estimate
      end

      # print the total estimate after the last vote
      puts (
         "Total vote value |          |" + 
         "%1$10.3f SBD".colorize(
            if _total_estimate > 0.0005 then
               :green
            elsif _total_estimate < -0.0005 then
               :red
            else
               :white
            end
         ) +
         " |           |                 |                     |") % [
            _total_estimate
         ]

      return
   end
```

To avoid replications the rest of the operation is described in the radiator chapter.

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Posting-Votes.rb).

The output of the command (for for one of my postings) looks like this:

<center>![Screenshot at Mar 14 10-57-12.png](https://cdn.steemitimages.com/DQmWyd41FC3mBzzfEe9bZe3f1YQxKWTSvBKyC4C6XpSmqeC/Screenshot%20at%20Mar%2014%2010-57-12.png)</center>

As you can see three of the votes have a zero estimate. Most interesting here is the 0.75% vote vote from @vannour which too has zero estimate.

## Implementation using radiator

To avoid replications the `Vote` class is only described in the steem-ruby chapter.

-----

The `Amount` class is used in most Scripts so it was moved into a separate file. You can find the source code in Git under [Radiator/Amount.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Radiator/Amount.rb)

```ruby
require_relative 'Radiator/Amount'
```

Load a few values from Condenser into global constants. This is only acceptable in short running scripts as the values are not actually constant but are updated by Condenser in regular intervals.

```ruby
begin
   # create instance to the steem condenser API which
   # will give us access to the active votes.

   Condenser_Api = Radiator::CondenserApi.new

   # read the global properties and median history values
   # and calculate the conversion Rate for steem to SBD
   # We use the Amount class from Part 2 to convert the
   # string values into amounts.

   _median_history_price = Condenser_Api.get_current_median_history_price.result
   _base                 = Amount.new _median_history_price.base
   _quote                = Amount.new _median_history_price.quote
   SBD_Median_Price      = _base.to_f / _quote.to_f

   # read the reward funds. `get_reward_fund` takes one
   # parameter is always "post" and extract variables
   # needed for the vote estimate. This is done just once
   # here to reduce the amount of string parsing needed.
   # `get_reward_fund` takes one parameter is always "post".

   _reward_fund   = Condenser_Api.get_reward_fund("post").result
   Recent_Claims  = _reward_fund.recent_claims.to_i
   Reward_Balance = Amount.new _reward_fund.reward_balance

rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Posting-Votes.rb).

The output of the command (for for one of my postings) looks like this:

<center>![Screenshot at Mar 14 10-58-50.png](https://cdn.steemitimages.com/DQmU7AAEiA9XHChBabWqBzgQrmBstymxv2HDXz4i1HcTsL5/Screenshot%20at%20Mar%2014%2010-58-50.png)</center>

In this output there is a 100% down vote from @camillesteemer — a well know down vote troll. However he is nothing to worry about as his down vote too has a zero estimate.

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 8](https://steemit.com/@krischik/using-steem-api-with-ruby-part-5)

## Next tutorial

* [Using Steem-API with Ruby Part 10](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7)

## Proof of Work

* GitHub: [SteemRubyTutorial Enhancement #11](https://github.com/krischik/SteemRubyTutorial/issues/11)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![Beneficiary](https://cdn.steemitimages.com/DQmdnAeXmyTiTyZQg8uEPssCEcRa7xL8nLHBrkEJ4dX2RPv/image.png)</center>

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
