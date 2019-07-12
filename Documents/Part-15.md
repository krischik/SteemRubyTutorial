# Using Steem-API with Ruby Part 15 — Print Steem Engine Token values

utopian-io tutorials ruby steem-api programming
utopian.pay

<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print-XXXXX.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-XXXXX.rb).

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

In this particular chapter you learn how to read the current exchange rates for steem engine token.

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

## Implementation using radiator

### [SCC/Steem_Engine.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/SCC/Steem_Engine.rb)

Base class for all steem engine classes. This class holds general constants and a lazy initialization to the contracts API.

```ruby
module SCC
   class Steem_Engine < Radiator::Type::Serializer
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :key, :value
```

Amount of rows read from database in a single query. If the overall results exceeds this limit then make multiple queries. 1000 seem to be the standard for Steem queries.

```ruby
      QUERY_LIMIT = 1000

```

To query all rows of an table an empty query and not a `nil` must be provided.

```ruby
      QUERY_ALL = {}
```

Provide an instance to access the Steem Engine API. The attribute is lazy initialized when first used and the script will abort when this fails. Note that this is only ok for simple scripts. If you write a complex web app you spould implement a more elaborate error handler.

```ruby

      class << self
         attr_reader :QUERY_ALL, :QUERY_LIMIT
         @api = nil

         ##
         # Access to contracts interface
         #
         # @return [Radiator::SSC::Contracts]
         #     the contracts API.
         #
         Contract None => Radiator::SSC::Contracts
         def contracts_api
            if @api == nil then
               @api = Radiator::SSC::Contracts.new
            end

            return @api
         rescue => error
            # I am using Kernel::abort so the code snipped
            # including error handler can be copy pasted into other
            # scripts

            Kernel::abort("Error creating contracts API :\n".red + error.to_s)
         end #contracts
      end # self
   end # Token
end # SCC

```

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [SCC/Steem_Engine.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/SCC/Steem_Engine.rb).

### [SCC/Metric.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/SCC/Metric.rb)

Most of the actual functionality is part of a new `SCC:Metric` class so it can be reused in further parts of the tutorial.

```ruby
require 'pp'
require 'colorize'
require 'contracts'
require 'radiator'
require 'json'

require_relative 'Steem_Engine'

module SCC
   ##
   # Holds the metrics of Steem Engine Token that is the
   # recent prices a steem engine token was traded.
   #
   class Metric < SCC::Steem_Engine
      include Contracts::Core
      include Contracts::Builtin

      attr_reader :key, :value,
                  :symbol,
                  :volume,
                  :volume_expiration,
                  :last_price,
                  :lowestAsk,
                  :highest_bid,
                  :last_day_price,
                  :last_day_price_expiration,
                  :price_change_steem,
                  :price_change_percent,
                  :loki

      public
```

The class contructor create instance form Steem Engine JSON object. Numeric data in strings are converted floating point values.

```ruby
         Contract Any => nil
         def initialize(metric)
            super(:symbol, metric.symbol)

            @symbol                    = metric.symbol
            @volume                    = metric.volume.to_f
            @volume_expiration         = metric.volumeExpiration
            @last_price                = metric.lastPrice.to_f
            @lowest_ask                = metric.lowestAsk.to_f
            @highest_bid               = metric.highestBid.to_f
            @last_day_price            = metric.lastDayPrice.to_f
            @last_day_price_expiration = metric.lastDayPriceExpiration
            @price_change_steem        = metric.priceChangeSteem.to_f
            @price_change_percent      = metric.priceChangePercent
            @loki                      = metric["$loki"]

            return
         end
```

Create a colorized string showing the current STEEMP value of the token. STEEMP us a steem engie token that can be exchanged 1:1, minus a 1% transaction fee, to STEEM. It's STEEMP which gives the token on Steem Engine it's value. 

The current highest bid is printed green, the current lowest asking price us printed in red and the last price of an actual transaction is printed on blue.

Unless the value is close to 0, then the value is greyed out. Reminder: Never use equality for floating point values to 0. Always use some ε value.

```ruby
         Contract None => String
         def to_ansi_s
            begin
               _retval = (
               "%1$-12s" +
                  " | " +
                  "%2$18.6f STEEM".colorize(
                     if @highest_bid > 0.000001 then
                        :green
                     else
                        :white
                     end
                  ) +
                  " | " +
                  "%3$18.6f STEEM".colorize(
                     if @last_price > 0.000001 then
                        :blue
                     else
                        :white
                     end
                  ) +
                  " | " +
                  "%4$18.6f STEEM".colorize(
                     if @lowest_ask > 0.000001 then
                        :red
                     else
                        :white
                     end) +
                  " | "
               ) % [
                  @symbol,
                  @highest_bid,
                  @last_price,
                  @lowest_ask
               ]
            rescue
               _retval = ""
            end

            return _retval
         end
```

Read the metric of a single token form the Steem Engine database and convert it into a `SCC::Metric` instance. The method `Steem_Engine.contracts_api.find_one` method is described in [Part 13](https://steemit.com/@krischik/using-steem-api-with-ruby-part-13). 

```ruby
         class << self
            ##
            #
            #  @param [String] name
            #     name of symbol
            #  @return [Array<SCC::Metric>]
            #     metric found
            #
            Contract String => Or[SCC::Metric, nil]
            def symbol (name)
               _metric = Steem_Engine.contracts_api.find_one(
                  contract: "market",
                  table:    "metrics",
                  query:    {
                     "symbol": name
                  })

               raise KeyError, "Symbol «" + name + "» not found" if _metric == nil

               return SCC::Metric.new _metric
            end
```

Read the metrics of all tokens form the Steem Engine database and convert it into a `SCC::Metric` instance. The method `Steem_Engine.contracts_api.find_one` method is described in [Part 14](https://steemit.com/@krischik/using-steem-api-with-ruby-part-14). 

```ruby
            ##
            #  Get all token
            #
            #  @return [SCC::Metric]
            #     metric found
            #
            Contract String => ArrayOf[SCC::Metric]

            def all
               _retval  = []
               _current = 0

               loop do
                  _metric = Steem_Engine.contracts_api.find(
                     contract:   "market",
                     table:      "metrics",
                     query:      Steem_Engine::QUERY_ALL,
                     limit:      Steem_Engine::QUERY_LIMIT,
                     offset:     _current,
                     descending: false)

                  # Exit loop when no result set is returned.
                  #
                  break if (not _metric) || (_metric.length == 0)
                  _retval += _metric.map do |_token|
                     SCC::Metric.new _token
                  end

                  # Move current by the actual amount of rows returned
                  #
                  _current = _current + _metric.length
               end

               return _retval
            end # all
         end # self
   end # Metric
end # SCC
```

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [SCC/Metric.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/SCC/Metric.rb).

### [Steem-Print-SCC-Metrics.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-SCC-Metrics.rb)

With all the functionality in classes the actual implementation is just a few lines:

```ruby
require_relative 'SCC/Metric'

_metrics = SCC::Metric.all

puts("Token        |               highes Bid |               last price |            lowest asking |")
puts("-------------+--------------------------+--------------------------+--------------------------+")

_metrics.each do |_metric|
   puts _metric.to_ansi_s
end
```

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-SCC-Metrics.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-SCC-Metrics.rb).

-----

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at XXXXX.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-ScreenshotXXXXX.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 14](https://steemit.com/@krischik/using-steem-api-with-ruby-part-14)

## Next tutorial

* [Using Steem-API with Ruby Part 16](https://steemit.com/@krischik/using-steem-api-with-ruby-part-16)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #17](https://github.com/krischik/SteemRubyTutorial/issues/17)

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
