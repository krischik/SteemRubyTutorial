# Using Steem-API with Ruby Part 6 — Print Posting Votes improved

utopian-io tutorials ruby steem-api programming

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

This installement teaches how to calculate the estimated values of all votes on all posting. How we get the lost was already described in [Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7)

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

All that is needed is to calculate the estimate with the fomular explained in [Part 8](https://steemit.com/@krischik/using-steem-api-with-ruby-part-8):

<center>![estimate = \frac{rshares}{recent\_claims \times reward\_balance \times sbd\_median\_price}](https://cdn.steemitimages.com/DQmQjroDqHAcPmS2zMUPphmMCKwz3FZFD9qB428iyhFKo8e/Estimate.png)</center>

## Implementation using steem-ruby

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Posting-Votes.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 13 145331.png](https://files.steempeak.com/file/steempeak/krischik/bj5gfctG-Screenshot20at20Feb20132014-53-31.png)</center>

## Implementation using radiator

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Posting-Votes.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at Feb 13 145420.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-Screenshot20at20Feb20132014-54-20.png)</center>

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

![Beneficiary.png](https://cdn.steemitimages.com/DQmYnQfCi8Z12jkaNqADKc37gZ89RKdvdLzp7uXRjbo1AHy/image.png)

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
