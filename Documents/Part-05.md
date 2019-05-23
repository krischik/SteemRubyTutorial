# Using Steem-API with Ruby Part 5 — Print Current Median History Price

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

In this instalment of the tutorial you learn how to access the conversion rate of STEEM and Steem Backed Dollars (SBD).

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

In the last part of the tutorial we took a look at the account wallet where we noted that steem power is shown on STEEM and not VESTS. If you look at the screen shot again you will notice that in the last row the estimated account value is quoted in '$':

<center>![Screenshot at Feb 04 142910.png](https://files.steempeak.com/file/steempeak/krischik/wacyfyC6-Screenshot20at20Feb20042014-29-10.png)</center>

It is important to know that this is not the account value in US$. Instead it's the account value in Steem Backed Dollars (SBD). One SBD is supposed to be about one US$ but this can vary. Which leads to the question: What is the exchange rate between SBD and STEEM?

This isn't documented in the official API documentation or the official tutorials. Unlike VESTS to STEEM conversion which is well documented.

What is documented is `get_current_median_history_price`. This value is a rolling median price for SBD and is provided by the Witnesses. Being a rolling median it's smother but also a little behind the actual price.

The `get_current_median_history_price` can be read using call to the `Condenser_Api` API. As you can see it returns not one but two values called `base` and `quote` and they are both ridiculously large:

<center>![Screenshot at Feb 12 081252.png](https://files.steempeak.com/file/steempeak/krischik/wCoppn7g-Screenshot20at20Feb20122008-12-52.png)</center>

How they are used isn't documented but it's possible to deduct the usage from the types: `base` is in SDB and `quote` in STEEM so a division is the way to go:

<center>![sbd=steem\frac{base}{quote}](https://files.steempeak.com/file/steempeak/krischik/UOoLKias-Steem_to_SBD.png)</center>

## Implementation using steem-ruby

Reading the `get_current_median_history_price` is pretty straight forward and similar to what you have learned [Part 3](https://steemit.com/@krischik/using-steem-api-with-ruby-part-3). The actual code samples are rather short after this much theory.

-----

```ruby
begin
```

Create instance to the steem condenser API which will give us, among other things, access to the median history price.

```ruby
   Condenser_Api = Steem::CondenserApi.new
```

Read the median history. Yes, it's as simple as this.

```ruby
   Median_History_Price = Condenser_Api.get_current_median_history_price
```

Calculate the conversion Rate for STEEM to SBD. We use a trick here: `to_f` ignores the text after the space which simplifies the code.

```ruby
   _base                 = Median_History_Price.result.base
   _quote                = Median_History_Price.result.quote
   Conversion_Rate_Steem = _base.to_f / _quote.to_f
rescue => error
```

I am using `Kernel::abort` so the code snipped including error handler can be copy pasted into other scripts.

```ruby
   Kernel::abort("Error reading global properties:
".red + error.to_s)
end
```

Pretty print the result. It might look strange to do so outside the begin / rescue but the value is now available in a constant for the rest of the script. Do note that using a constant is only suitable for short running script. Long running scripts would need to re-read the value on a regular basis.

```ruby
pp Median_History_Price
```

Show some actual sample conversion rates:

```ruby
puts ("1.000 STEEM = %1$15.3f SBD")   % (1.0 * Conversion_Rate_Steem)
puts ("1.000 SBD   = %1$15.3f STEEM") % (1.0 / Conversion_Rate_Steem)
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem-Dump-Median-History-Price.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Median-History-Price.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 12 143024.png](https://files.steempeak.com/file/steempeak/krischik/j1lLcMQK-Screenshot20at20Feb20122014-30-24.png)</center>

## Implementation using radiator

It's pretty much indentical to the radiator implementaiton.

-----

```ruby
begin
```

Create instance to the steem condenser API which will give us access to the median history price.

```ruby
   Condenser_Api = Radiator::CondenserApi.new
```

Read the median history. Yes, it's as simple as this.

```ruby
   Median_History_Price = Condenser_Api.get_current_median_history_price
```

Calculate the conversion Rate for STEEM to SBD. We use a trick here: `to_f` ignores the text after the space which simplifies the code.

```ruby
   _base                 = Median_History_Price.result.base
   _quote                = Median_History_Price.result.quote
   Conversion_Rate_Steem = _base.to_f / _quote.to_f
rescue => error
```

I am using `Kernel::abort` so the code snipped including error handler can be copy pasted into other scripts.

```ruby
   Kernel::abort("Error reading global properties:
".red + error.to_s)
end
```

Pretty print the result. It might look strange to do so outside the begin / rescue but the value is now available in a constant for the rest of the script. Do note that using constant is only suitable for short running script. Long running scripts would need to re-read the value on a regular basis.

```ruby
pp Median_History_Price
```

Show some actual sample conversion rates:

```ruby
puts ("1.000 STEEM = %1$15.3f SBD")   % (1.0 * Conversion_Rate_Steem)
puts ("1.000 SBD   = %1$15.3f STEEM") % (1.0 / Conversion_Rate_Steem)
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem-Print-Median-History-Price.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Median-History-Price.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at Feb 12 143118.png](https://files.steempeak.com/file/steempeak/krischik/4lqTXfUp-Screenshot20at20Feb20122014-31-18.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 4](https://steemit.com/@krischik/using-steem-api-with-ruby-part-4)

## Next tutorial

* [Using Steem-API with Ruby Part 6](https://steemit.com/@krischik/using-steem-api-with-ruby-part-6)

## Proof of Work

* [SteemRubyTutorial Issue #6](https://github.com/krischik/SteemRubyTutorial/issues/6)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

![image.png](https://files.steempeak.com/file/steempeak/krischik/n389ribv-image.png)

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->::
