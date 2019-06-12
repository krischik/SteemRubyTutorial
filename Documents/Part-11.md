# Using Steem-API with Ruby Part 11 — Using Mechanize to improve performance

utopian-io tutorials ruby steem-api programming

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-mechanize sample code: [Steem-Dump-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Vesting.rb)

### steem-mechanize

* Project Name: Steem Mechanize
* Repository: [https://github.com/steemit/steem-mechanize](https://github.com/steemit/steem-mechanize)
* Official Documentation: [https://www.rubydoc.info/gems/steem-mechanize](https://www.rubydoc.info/gems/steem-mechanize)
* Official Tutorial: N/A

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. When using Ruby you have three APIs available to chose: **steem-api**, **steem-mechanize** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **steem-mechanize** drop in replacement for steem-api with more performat network I/O
* **radiator** uses classic function return values and provides high level human readable data.

This tutorial takes a special look at the **steem-mechanize** API.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
gem install steem-mechanize
```

**Note:** All APIs steem-ruby, steem-mechanize and radiator provide a file called `steem.rb`. This means that:

1. When more then one APIs is installed ruby must be told which one to use.
2. The three APIs can't be used in the same script.

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

Printing all delegation from and to a list of accounts, as shown in the [last tutorial](https://steemit.com/@krischik/using-steem-api-with-ruby-part-10), hast proven to be a time consuming operation — easily lasting over an hour.

On way to improve performance is to skip over the delegations of the “steem” account who delegates to most accounts below a steem power of ≈30000 VEST / 15 STEEM. This brings the run time down to about half an hour. Which is still a lot.

Another way to improve performance is the use of [steem-mechanize](https://github.com/steemit/steem-mechanize) a combination of [steem-ruby](https://github.com/steemit/steem-ruby) and [mechanize](https://github.com/sparklemotion/mechanize). Mechanize improved performance by using [Persistent HTTP connections](https://en.wikipedia.org/wiki/HTTP_persistent_connection).

## Implementation using steem-mechanize

steem-mechanize is a drop in replacement for steem-ruby and theoretically the only change to the code needed is the use of `require  'steem-mechanize'` instead  `require  'steem-ruby'`.

-----

```ruby
# use the "steem.rb" file from the steem-ruby gem. This is
# only needed if you have both steem-api and radiator
# installed.

gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
require 'steem-mechanize'

# The Amount class is used in most Scripts so it was moved
# into a separate file.

require_relative 'Steem/Amount'
```

However in praxis there is one more Problem: [steem-mechanize](https://github.com/steemit/steem-mechanize) is to fast for https://api.steemit.com and you will be get an “Error 403” / “HTTP Forbidden” if you try.

<center>![Screenshot at May 29 12-52-01.png](https://cdn.steemitimages.com/DQmbEgp3TV1i6LomjAmNmXwmxBrU3S8mXeLmj38Ubxoat24/Screenshot%20at%20May%2029%2012-52-01.png)</center>

This suggest that Steemit has an upper limit on how many the accesses per seconds it allows which makes it necessary to add additional error handling and a little `sleep`. To avoid duplication only the differences to the original version is shown.

At the beginning of the file a constant indicating the maximum retries to be done.

```ruby
##
# Maximum retries to be done when a
#
Max_Retry_Count = 3
```

At the beginning of the main loop a retry counter is added.

```ruby
      # empty strings denotes start of list

      _previous_end = ["", ""]

      # counter keep track of the amount of retries left

      _retry_count = Max_Retry_Count

      loop do
```

At then end of the loop a `sleep` is added to throttle the loop to 20 http requests per second. Test have shown that this is usually enough to make the loop run though.

For the few cases where throttling is not sufficient an error handler is added to allow up to three (`Max_Retry_Count`) retries.

```ruby
         # Throttle to 20 http requests per second. That
         # seem to be the acceptable upper limit for
         # https://api.steemit.com

         sleep 0.05

         # resets the counter that keeps track of the
         # retries.

         _retry_count = Max_Retry_Count
      rescue => error
         if _retry_count == 0 then
            # We made Max_Retry_Count repeats ⇒ giving up.

            print Delete_Line
            Kernel::abort ("\nCould not read %1$s with %2$d retrys :\n%3$s".red) % [_previous_end, Max_Retry_Count, error.to_s]
         end

         # wait one second before making the next retry

         _retry_count = _retry_count - 1
         sleep 1.0
      end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Vesting.rb).

The output of the command (for my own and  the steem account) looks just like before:

<center>![Screenshot at May 29 14-02-41.png](https://cdn.steemitimages.com/DQmYbrguwQ9khfKmjp2zUNHULyqEZYM3YcSKEuTszz5kDRr/Screenshot%20at%20May%2029%2014-02-41.png)</center>

However it steem-mechanize version is just about 2½ faster:

|API used         | Time elapsed |
|-----------------|--------------|
| steem-ruby      |       27'58" |
| steem-mechanize |       11'49" |

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 10](https://steemit.com/@krischik/using-steem-api-with-ruby-part-10)

## Next tutorial

* [Using Steem-API with Ruby Part 12](https://steemit.com/@krischik/using-steem-api-with-ruby-part-12)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #13](https://github.com/krischik/SteemRubyTutorial/issues/13)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![](https://cdn.steemitimages.com/DQmNg1qvYP2GFxxDmuyQr4wVtKQVyXGZqKKH3mNEYWRzvrh/image.png)</center>

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
