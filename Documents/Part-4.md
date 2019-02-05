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

In this 4th part you learn how VESTS, Steem Power and STEEM are connected and can be converted.


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

You should also have read [Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2) and [Part 3](https://steemit.com/@krischik/using-steem-api-with-ruby-part-4) of the tutorial as this part build on them.

If there is anything not clear you can ask in the comments.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

When you take a look at your account wallet you find three values: Steem, Steem Power and Steem Dollar.

![Screenshot at Feb 04 142910.png](https://files.steempeak.com/file/steempeak/krischik/wacyfyC6-Screenshot20at20Feb20042014-29-10.png)

With both Steem and Steem Power measured in Steem and Steem Dollar in SBD os just a $ sign. However, if you look at the output of [Tutorial Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2) you will see that there is no Steem Power — just a few ridiculous large values called vesting measured in VESTS:

![Screenshot at Jan 27 17-44-14.png](https://ipfs.busy.org/ipfs/QmS3Cd7342izfri5EXGTcGYTCvNzUEWELASy8z4hFuSMso)

This vesting is the Steem Power. However since VESTS values are ridiculous large they are usually not displayed anywhere in the user interface. Instead the amount of Steem needed buy the VESTS (called power up) or you get when you sell your VESTS (called power down) is displayed. The conversion is done by the following formula:

![steem = vest \frac{total\_vesting\_fund\_steem}{total\_vesting\_shares}](https://ipfs.busy.org/ipfs/QmfH95PyxxyTpc9N9GcXoxaPA9WAyVJ39WPs7x2r3Kbho8)

Note that `total_vesting_fund_steem` and `total_vesting_shares` aren't constant and this is the reason why it seems that your Steem power is slowly increasing for no apparent reason: VESTS are constantly getting more expensive and the user interface is showing the amount of Steem you would get if you sell your VESTS today.

After all this theory let's get to the practical part. I made a VESTS to Steem script using `steem-ruby` and a Steem to VESTS script using `radiator`. In example calls I convert the Steem Power of the various user level:

<table>
  <thead>
    <tr>
      <th>Logo</th>
      <th>Level</th>
      <th>Your Steem Power in VESTS</th>
      <th>Your Steem Power in Steem</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><img src="https://img.esteem.ws/ph3r1fyc8f.png"></td>
      <td>Plankton</td>
      <td>0 to 999'999 VESTS</td>
      <td>0 to ≈500 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/0x0/https://img.esteem.ws/h3oygwjq8x.png"></td>
      <td>Minnow</td>
      <td>1'000'000 to 9'999'999 VESTS</td>
      <td>≈500 to ≈5'000 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/0x0/https://img.esteem.ws/m3joaelsa7.png"></td>
      <td>Dolphin</td>
      <td>10'000'000 to 99'999'999 VESTS</td>
      <td>≈5'000 to ≈50'000 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/0x0/https://img.esteem.ws/ngf0rg6mqy.png"></td>
      <td>Ocra</td>
      <td>100'000'000 to 999'999'999 VESTS</td>
      <td>≈50'000 to ≈500'000 Steem</td>
    </tr>
    <tr>
      <td><img src="https://steemitimages.com/0x0/https://img.esteem.ws/msa89atwso.png"></td>
      <td>Whale</td>
      <td>more than 1'000'000'000 VESTS</td>
      <td>more than ≈500'000 Steem</td>
    </tr>
  </tbody>
</table>

**Note:** I don't copy paste the whole scripts any more as this would just be repetitive. Just the part needed to understand the lesson. The fully commented and fully functional scripts are available on [Github](https://github.com/krischik/SteemRubyTutorial/tree/master/Scripts).

## Implementation using steem-ruby

The first script [Steem_From_VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem_From_VEST.rb) converts VESTS to Steem:

-----

Shows usage help if the no values are given to convert.

```ruby
if ARGV.length == 0 then
   puts """
Steem_From_VEST — Print convert list of VESTS value to Steem values

Usage:
   Steem-Print-Balances values …

"""
else
```

read arguments from command line

```ruby
   Values = ARGV
```

Calculate the conversion Rate. We use the Amount class from [Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2) to convert the string values into amounts.

```ruby
   _total_vesting_fund_steem = Amount.new Global_Properties.total_vesting_fund_steem
   _total_vesting_shares     = Amount.new Global_Properties.total_vesting_shares
   _conversion_rate          = _total_vesting_fund_steem / _total_vesting_shares
```

iterate over the valued passed in the command line

```ruby
   Values.each do |value|
```

convert the value to steem by multiplying with the conversion rate and display the value

```ruby
      _steem = value.to_f * _conversion_rate
      puts "%1$18.6f VESTS = %2$15.3f STEEM" % [value, _steem]
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem_From_VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem_From_VEST.rb).

The output of the command (for the steem account) looks like this:

![Screenshot at Feb 04 165002.png](https://files.steempeak.com/file/steempeak/krischik/jLeQPYTY-Screenshot20at20Feb20042016-50-02.png)

As you can see the Steem values of the user levels are slightly below 500, 5000, … . 

## Implementation using radiator

The second script [Steem_To_VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem_To_VEST.rb) converts VESTS to Steem. Apart from printout there is only one character difference.

-----

Shows usage help if the no values are given to convert.

```ruby
if ARGV.length == 0 then
   puts """
Steem_To_VEST — Print convert list of Steem value to VESTS values

Usage:
   Steem-Print-Balances values …

"""
else
```

read arguments from command line

```ruby
   Values = ARGV
```

Calculate the conversion Rate. We use the Amount class from [Part 2 of the tutorial](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2) to convert the string values into amounts.

```ruby
   _total_vesting_fund_steem = Amount.new Global_Properties.total_vesting_fund_steem
   _total_vesting_shares     = Amount.new Global_Properties.total_vesting_shares
   _conversion_rate          = _total_vesting_fund_steem / _total_vesting_shares
```

iterate over the valued passed in the command line

```ruby
   Values.each do |value|
```

convert the value to steem by dividing with the conversion rate and display the value. Here is the actual difference: A division instead of a multiplication.

```ruby
      _vest = value.to_f / _conversion_rate
      puts "%1$15.3f STEEM = %2$18.6f VEST" % [value, _vest]
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with syntax highlighting: [Steem_To_VEST.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem_To_VEST.rb).

The output of the command (for the steem account) looks identical to the previous output:

![Screenshot at Feb 05 141113.png](https://files.steempeak.com/file/steempeak/krischik/Vj96MH4f-Screenshot20at20Feb20052014-11-13.png)

And coming form the other way, converting 500, 5000 … we now get slightly larger VESTS then 1 million, 10 million … . Remember, by the time you read this VEST will

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 3](https://steemit.com/@krischik/using-steem-api-with-ruby-part-3)

## Next tutorial

* [Using Steem-API with Ruby Part 5](https://steemit.com/@krischik/using-steem-api-with-ruby-part-5)

## Proof of Work

* [SteemRubyTutorial Issue #5](https://github.com/krischik/SteemRubyTutorial/issues/5)

![image.png](https://files.steempeak.com/file/steempeak/krischik/OJZDys0B-image.png)

<center> ![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png) </center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->:
