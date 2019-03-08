# Using Steem-API with Ruby Part 8 — Print Account Balances with vote power

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* radiator sample code: [Steem-Print.Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Balances.rb).

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. This instalment teacher how to estimate a users vote value.
 
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

Estimating the vote value is a rather complex process involving all of the following variables needed from :

| Name			    | API						| Description				|
|---------------------------|---------------------------------------------------|---------------------------------------|
|`weight`		    |chosen by the user					|Weight of vote in %. ¹			|
|current `voting_power`²    |calculated from the voting power of the  last vote	|Current voting power in %. ¹		|
|last_vote_time		    |DatabaseApi.get_accounts				|Last time the user voted in UTC.	|
|last `voting_power`²	    |DatabaseApi.get_accounts				|Voting power at last vote in %. ¹	|
|`vesting_shares`	    |DatabaseApi.get_accounts				|VESTS owned by account			|
|`received_vesting_shares`  |DatabaseApi.get_accounts				|VESTS delegated from other accounts	|
|`delegated_vesting_shares` |DatabaseApi.get_accounts				|VESTS delegated to other accounts	|
|`recent_claims`	    |CondenserApi.get_reward_fund			|Recently made claims on reward pool	|
|`reward_balance`	    |CondenserApi.get_reward_fund			|Reward pool				|
|`sbd_median_price`	    |calulated from base and quote			|Conversion rate steem ⇔ SBD		|
|`base`			    |CondenserApi.get_current_median_history_price	|Conversion rate steem ⇔ SBD		|
|`quote`		    |CondenserApi.get_current_median_history_price	|Conversion rate steem ⇔ SBD		|

**Notes:**

* ¹ : Stored as fixed point with 4 decimal places and need to be divided by 10⁴ before usage.
* ² : Both the current and the last voting_power is called voting_power in the official documentation which maybe confusing.
* ³ : The UTC marker is missing and must be added before converting the string into a date/time.

### Step 1 Calculate SBD Median Price 

To improve precision of any calculation the Steem database only stores integer numbers. In case of the SDB median price is stored as quotient or fraction which we just divide them as floating point number are good enough for an estimate.

<center>![sbd\_median\_price = \frac{base}{quote}](https://cdn.steemitimages.com/DQmcYAvStASmtaR7htYzCCcgTpQtxu4TYbxTgarNf1aq4q1/SBD_Median_Price.png)</center>

### Step 2 Calculate the users voting power 

The database only stores the users voting power at the time of last vote. This makes it necessary to add the voting power regained since the last vote. This is done with following formula:

<center>![current\_voting\_power = voting\_power + \frac{seconds\_ago}{five\_days}](https://cdn.steemitimages.com/DQmZafbe18NBJwKruZN4EJKiuAeFpHC6e1CCoVHHhpmWqwJ/Current_Voting_Power.png)</center>

Note that the vote power is bounded between 0% (0.0) and 100% (1.0).

### Step 3 Calculate the users VESTS

The users VESTS is calculated by adding and subtracting the in and  delegates from the accounts VESTS and your multiply the result with 10⁶ (aka one million). 

<center>![total\_vests = vesting\_shares + received\_vesting\_shares - delegated\_vesting\_shares](https://cdn.steemitimages.com/DQmV9sG6wNDSmrkbqedve1jj2vfurPm8GQrxPUopRNtLbM4/Final_Vest.png)</center>

### Step 4 Calculate Reward Share

The share of the rewards pool is then calculated by multiplying the power and the VESTS.

<center>![rshares = power \times final\_vest](https://cdn.steemitimages.com/DQmfMbTbeBw3tQQBTxHWdw2EWVMMwU4GVpGrYMX46wWCbmf/RShares.png)</center>

### Step 5 Calculate the actual estimate

The estimate is calculated from the data of the most recent distribution. For this the reward share is divided by the amount of claims done last time and multiplied by the available reward pool. The result is the reward in Steem which is then then converted to SBD by multiplying it with the SBD median price.

<center>![estimate = \frac{rshares}{recent\_claims \times reward\_balance \times sbd\_median\_price}](https://cdn.steemitimages.com/DQmQjroDqHAcPmS2zMUPphmMCKwz3FZFD9qB428iyhFKo8e/Estimate.png)</center>

Those who opt for a 100% power up might prefer a printout in Steem. For this leave out the multiplication with the sbd median price. But remember that the dust value is calculated in SBD and only postings with a payout of least 0.020 SBD will actually be payed out.

## Implementation using steem-ruby

Since `DatabaseApi.get_accounts` of steem-api doesn't return the `voting_power` only the radiator implementation is included.

## Implementation using radiator

`Steem-Print-Balances.rb` has been explained before in [Part 2](https://steemit.com/@krischik/using-steem-api-with-ruby-part-2) and [Part 6](https://steemit.com/@krischik/using-steem-api-with-ruby-part-6) of the tutorial and to avoid redundancy only the new functionality is described. 

Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

-----

`Conversion_Rate_Steem` was renamed `SBD_Median_Price` because that's the name used in the official documentation.

```ruby
   SBD_Median_Price      = _base.to_f / _quote.to_f
```

Read the reward funds. `get_reward_fund` takes one parameter is always "post".

```ruby
   _reward_fund =  _condenser_api.get_reward_fund("post").result
```

Extract variables needed for the vote estimate. This is done just once here to reduce the amount of string parsing needed.

```ruby
   Recent_Claims  = _reward_fund.recent_claims.to_i
   Reward_Balance = Amount.new _reward_fund.reward_balance
```

Calculate the real voting power of an account. The voting power in the database is only updated when the user makes an up vote and needs to calculated from there.  

```ruby
def real_voting_power (account)
   _last_vote_time = Time.strptime(account.last_vote_time + ":Z" , "%Y-%m-%dT%H:%M:%S:%Z")
   _current_time = Time.now
   _seconds_ago = _current_time - _last_vote_time;
   _voting_power = account.voting_power.to_f / 10000.0
   _retval = _voting_power + (_seconds_ago / Five_Days)

   if _retval > 1.0 then
      _retval = 1.0
   end

   return _retval.round(4);
end

…

_voting_power             = real_voting_power account
```

Calculate actual vesting by adding and subtracting delegation as well at the final vest for vote estimate.

```ruby
      _total_vests = _vesting_shares - _delegated_vesting_shares + _received_vesting_shares
      _final_vest  = _total_vests.to_f * 1e6
```

Calculate the vote value for 100% up votes.

```ruby
      _weight = 1.0
```

Calculate the account's current vote value for a 100% up vote.

```ruby
      _current_power = (_voting_power * _weight) / 50.0
      _current_rshares = _current_power * _final_vest
      _current_vote_value = (_current_rshares / Recent_Claims) * Reward_Balance.to_f * SBD_Median_Price
```

Calculate the account's maximum vote value for a 100% up vote.  

```ruby
      _max_voting_power = 1.0
      _max_power = (_max_voting_power * _weight) / 50.0
      _max_rshares = _max_power * _final_vest
      _max_vote_value = (_max_rshares / Recent_Claims) * Reward_Balance.to_f * SBD_Median_Price
```

Print the current and maximum vote value. Colourise the current vote value depending on the voting power. If the vote value is 1.0 then colourise green and otherwise colourise red.

```ruby
      puts ("  Voting Power    = " +
         "%1$15.3f SBD".colorize(
            if _voting_power == 1.0 then
               :green
            else
               :red
            end
         ) + " of " + "%2$1.3f SBD".blue) % [
         _current_vote_value,
         _max_vote_value]
```

-----

The output of the command (for the steem account) looks like this

<center>![Screenshot at Mar 06 15-52-11.png](https://cdn.steemitimages.com/DQmNtYn28Rs97DUP8JWLbHXW8mYcKmoJha2vNRYhH5PzjFH/Screenshot%20at%20Mar%2006%2015-52-11.png)</center>

The current vote value is printed in red as a vote power is not at it's maximum. However the difference between the current vote value und the maximum vote value is smaller then 0.0005 SDB so the difference isn't shown.

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 5](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7)

## Next tutorial

* [Using Steem-API with Ruby Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-9)

## Proof of Work

* GitHub: [SteemRubyTutorial Enhancement #10](https://github.com/krischik/SteemRubyTutorial/issues/10)

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
