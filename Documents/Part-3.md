# Using Steem-API with Ruby Part 3

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

In this 3nd part you learn the request the get the dynamic global properties. This properties can, for example, be used  to convert VESTS balances into the more common STEEM balances. You use that with this formula:

![steem = vest \frac{total\_vesting\_fund\_steem}{total\_vesting\_shares}](https://ipfs.busy.org/ipfs/QmfH95PyxxyTpc9N9GcXoxaPA9WAyVJ39WPs7x2r3Kbho8)

In the next tutorial we will upgrade `Steem-Dump-Balances.rb` and `Steem-Print-Balances.rb` to show steem and vest balances side by side.

## Requirements

You should have basic knowledge of Ruby programming you need to install at least Ruby 2.5 as well as the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install steem-ruby
gem install radiator
```

If there is anything not clear you can ask in the comments.

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When you install both APIs you need to tell ruby which one to use.
2. You can't use both APIs in the same script.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

The easiest way to get the dynamic global properties is the use of `Steem::CondenserApi` or `Radiator::CondenserApi`. On the surface both work the same. Underneath there is a slight difference:

* steem-ruby only checks https://api.steemit.com for the data.
* Radiator has a list of 12 fall back server to check.

This makes radiator calls slightly more reliable.

**Note:** Starting with this tutorial I won't copy paste the whole script any more as this would just be repetitive. Just the part needed to understand the lesson. The fully commented and fully functional scripts are still available on [Github](https://github.com/krischik/SteemRubyTutorial/tree/master/Scripts).

## Implementation using steem-ruby

[Steem-Dump-Global-Properties.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Global-Properties.rb):

-----

Errors are handled via exceptions.

```ruby
begin
```

Create instance to the steem condenser API which will give us access to

```ruby
   Condenser_Api = Steem::CondenserApi.new
```

Read the global properties. Yes, it's as simple as this.

```ruby
   Global_Properties = Condenser_Api.get_dynamic_global_properties
rescue => error
```

I am using Kernel::abort so the code snipped including error handler can be copy pasted into other scripts. You certainly don't want to continue the script when the global properties are not available.

```ruby
   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

Pretty print the result. It might look strange to do so outside the begin / rescue but the value is now available in constant for the rest of the script. Do note that using constant is only suitable for short running script.  Long running scripts would need to re-read the value on a regular basis.

```ruby
pp Global_Properties
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem-Dump-Global-Properties.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Global-Properties.rb).

The output of the command (for the steem account) looks like this:

![Screenshot at Jan 30 11-34-40.png](https://ipfs.busy.org/ipfs/QmPXJVJFML22ixcWXzd7LP5hmkqefv68majDT1eCVj1Qyi)

## Implementation using radiator

[Steem-Print-Global-Properties.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Global-Properties.rb)

-----

Errors are handled via exceptions.

```ruby
begin
```

Create instance to the steem condenser API which will give us access to

```ruby
   Condenser_Api = Radiator::CondenserApi.new
```

Read the global properties. Yes, it's as simple as this.

```ruby
   Global_Properties = Condenser_Api.get_dynamic_global_properties
rescue => error
```

I am using Kernel::abort so the code snipped including error handler can be copy pasted into other scripts. You certainly don't want to continue the script when the global properties are not available.

```ruby
   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

Pretty print the result. It might look strange to do so outside the begin / rescue but the value is now available in constant for the rest of the script. Do note that using constant is only suitable for short running script.  Long running scripts would need to re-read the value on a regular basis.

```ruby
pp Global_Properties
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem-Print-Global-Properties.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Global-Properties.rb).

The output of the command (for the steem account) looks identical to the previous output:

![Screenshot at Jan 30 11-35-37.png](https://ipfs.busy.org/ipfs/Qmcw3372Me1RskQ9HLZuubj1BEyFXK3uYGdfHRfYMv4rLD)

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2)

## Next tutorial

* [Using Steem-API with Ruby Part 4](https://steemit.com/@krischik/using-steem-api-with-ruby-part-4)

## Proof of Work

* [SteemRubyTutorial Issue #4](https://github.com/krischik/SteemRubyTutorial/issues/4)

![image.png](https://files.steempeak.com/file/steempeak/krischik/2j20UjyR-image.png)

<center> ![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png) </center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
