# Using Steem-API with Ruby Part 6

utopian-io tutorials ruby steem-api programming

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories
### SteemRubyTutorial

You can find all examples from this tutorial as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)

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

Since both APIs have advantages and disadvantages I have provided sample code for both APIs so you can decide which is more suitable for you.

In this part of the tudorial we revise the `Steem-Dump-Balances.rb` and `Steem-Print-Balances.rb` to print convert all values into each other and calculate the account value.

## Requirements

You should have basic knowledge of Ruby programming you need to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install steem-ruby
gem install radiator
```

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When you install both APIs you need to tell ruby which one to use.
2. You can't use both APIs in the same script.

This part of the tutorial builds on the part 2 … 5 and you need to read them first.

If there is anything not clear you can ask in the comments.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

In [Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2) of the tutorial we printed out the account balances. However the values where not the way we are used. The steem power is printed in VESTS which are increadbly large number and the estimated account was missing from the output:

<center>![Screenshot at Jan 27 17-44-14.png](https://ipfs.busy.org/ipfs/QmS3Cd7342izfri5EXGTcGYTCvNzUEWELASy8z4hFuSMso)</center>

In this part of the tutorial we return the `Steem-Dump-Balances.rb` and `Steem-Print-Balances.rb` to improve the output and give us more informations. For this we will use a creatly improved `Amount`class. Since we already have all the theoretical knowledge we delve right into the code.

## Implementation using steem-ruby

-----

```ruby

```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem-Dump-Median-History-Price.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Median-History-Price.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 12 081252.png](https://files.steempeak.com/file/steempeak/krischik/NJPyw50I-Screenshot20at20Feb20122008-12-52.png)</center>

## Implementation using radiator

-----

```ruby

```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem-Print-Median-History-Price.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Median-History-Price.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at Feb 12 081512.png](https://files.steempeak.com/file/steempeak/krischik/Ww5w9IHw-Screenshot20at20Feb20122008-15-12.png)</center>

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 5](https://steemit.com/@krischik/using-steem-api-with-ruby-part-5)

## Next tutorial

* [Using Steem-API with Ruby Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7)

## Proof of Work

* [SteemRubyTutorial Issue #6](https://github.com/krischik/SteemRubyTutorial/issues/6)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->::
