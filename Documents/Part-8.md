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

<center>![SBD_Median_Price.png](https://cdn.steemitimages.com/DQmcYAvStASmtaR7htYzCCcgTpQtxu4TYbxTgarNf1aq4q1/SBD_Median_Price.png)</center>

### Step 2 Calculate the users voting power 

The database only stores the users voting power at the time of last vote. This makes it necessary to add the voting power regained since the last vote. This is done with following formula

<center>![Current_Voting_Power.png](https://cdn.steemitimages.com/DQmZafbe18NBJwKruZN4EJKiuAeFpHC6e1CCoVHHhpmWqwJ/Current_Voting_Power.png)</center>

### Step 3 Calculate the users VESTS

<center>![Final_Vest.png](https://cdn.steemitimages.com/DQmV9sG6wNDSmrkbqedve1jj2vfurPm8GQrxPUopRNtLbM4/Final_Vest.png)</center>

### Step 4 Calculate Reward Share

<center>![RShares.png](https://cdn.steemitimages.com/DQmfMbTbeBw3tQQBTxHWdw2EWVMMwU4GVpGrYMX46wWCbmf/RShares.png)</center>

### Step 5 Calculate the actual estimate

<center>![Estimate.png](https://cdn.steemitimages.com/DQmQjroDqHAcPmS2zMUPphmMCKwz3FZFD9qB428iyhFKo8e/Estimate.png)</center>

## Implementation using steem-ruby

Since `DatabaseApi.get_accounts` of steem-api doesn't return the `voting_power`  only the radiator implementation is included.

## Implementation using radiator

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

The output of the command (for the steem account) looks like this

<center>![Screenshot at Mar 06 15-52-11.png](https://cdn.steemitimages.com/DQmNtYn28Rs97DUP8JWLbHXW8mYcKmoJha2vNRYhH5PzjFH/Screenshot%20at%20Mar%2006%2015-52-11.png)</center>

The current vote value is printed in as a vote power is not at it's maximum. Maximum and current vote value are displayed the same as the reduction is less then 0.001 SBD. 

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 5](https://steemit.com/@krischik/using-steem-api-with-ruby-part-7)

## Next tutorial

* [Using Steem-API with Ruby Part 7](https://steemit.com/@krischik/using-steem-api-with-ruby-part-9)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #7](https://github.com/krischik/SteemRubyTutorial/issues/7)

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
