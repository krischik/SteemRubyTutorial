# Using Steem-API with Ruby Part 4

utopian-io tutorials ruby steem-api programming

![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)

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

In this installment of the tutorial you learn how to convert Steem and Steem Backed Dollars in order to calculate the account value

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

If there is anything not clear you can ask in the comments.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

In the last part of the tutorial we took a look at the account wallet where we noted that steem power is shoen on Steem and not VESTS. In the last row you will also notice the estimated account value in $:

![Screenshot at Feb 04 142910.png](https://files.steempeak.com/file/steempeak/krischik/wacyfyC6-Screenshot20at20Feb20042014-29-10.png)

It is important to know that this is not the account value in US$ but the account value in Steem Backed Dollars (SBD). This leaves us with the question: How are the SBD values for Steem calculated?

Sadly this is not as well documented in the official API documentation and tutorials as it was the case for the VESTS to Steem conversion. So a little reverse engineering is needed to figure this out.

The value needed to convert Steem value into SDB values is called `get_current_median_history_price` and can be read using call to the `Condenser_Api`. Only it's not one but two values and they are both ridiculously large:

SCREENSHOT.




**Note:** I don't copy paste the whole scripts any more as this would just be repetitive. Just the part needed to understand the lesson. The fully commented and fully functional scripts are available on [Github](https://github.com/krischik/SteemRubyTutorial/tree/master/Scripts).

## Implementation using steem-ruby

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem_From_VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem_From_VEST.rb).

The output of the command (for the steem account) looks like this:

## Implementation using radiator

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem_To_VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem_To_VEST.rb).

The output of the command (for the steem account) looks identical to the previous output:

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 3](https://steemit.com/@krischik/using-steem-api-with-ruby-part-4)

## Next tutorial

* [Using Steem-API with Ruby Part 5](https://steemit.com/@krischik/using-steem-api-with-ruby-part-6)

## Proof of Work

* [SteemRubyTutorial Issue #5](https://github.com/krischik/SteemRubyTutorial/issues/5)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Steem Power logos: [SteemitBoard](http://steemitboard.com), @captaink
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center> ![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png) </center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->:
