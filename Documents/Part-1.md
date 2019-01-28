# Using Steem-API with Ruby Part 1


## Repository

### steem-ruby

Project Name: Steem Ruby
Repository: https://github.com/steemit/steem-ruby

### radiator

Project Name: Radiator
Repository: https://github.com/inertia186/radiator

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. When using Ruby you have two APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages I have provided sample code for both APIs so you can decide which is more suitable for you.

## Requirements

You should have basic knowledge of Ruby programming and have an up to date ruby installed on your computer. If there is anything not clear you can ask in the comments.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Preparations

In order to use the provided sample you need to install the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install steem-ruby
gem install radiator
```

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:
1. When you install both APIs you need to tell ruby which one to use.
2. You can't use both APIs in the same script.

## Tutorial Contents

In this first part of the tutorial we I demonstrate how to print out account informations from a list of accounts passed on command line. The data is taken from the Steem database.

As mentioned there will be two examples and both samples are complete with error handling. I do this because error handling is one of the areas where steem-api and radiator differ and also it's always good to learn how to handle error condition correctly.

## Implementation using steem-ruby

First I show you how to get the account informations using steem-ruby. I called the script `[Steem-Dump-Accounts.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Sources/Steem-Dump-Accounts.rb)` as the output is more low level. Check out the comments in the sample code for details.

```ruby
#!/opt/local/bin/ruby

# use the "steem.rb" file from the steem-ruby gem. This is only needed if you have
# both steem-api and radiator installed.

gem "steem-ruby", :require => "steem"

require 'pp'
require 'colorize'
require 'steem'

if ARGV.length == 0 then
   puts """
Steem-Dump-Accounts — Dump account infos from Steem database

Usage:
   Steem-Dump-Accounts accountname …

"""
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Steem::DatabaseApi.new

   # request account informations from the Steem database and print out
   # the accounts found using pretty print (pp) or print out error
   # informations when an error occurred.

   Database_Api.find_accounts(accounts: Account_Names) do |result|
      Accounts = result.accounts

      if Accounts.length == 0 then
         puts "No accounts found.".yellow
      else
         pp Accounts
      end
   rescue => error
      puts "Error reading accounts:".red
      pp error
   end
end
```

The output of the command (for the steemit account) looks like this:

```
>ruby Steem-Dump-Accounts.rb steemit
[{"id"=>28,
  "name"=>"steemit",
  "owner"=>
   {"weight_threshold"=>1,
    "account_auths"=>[],
    "key_auths"=>
     [["STM6Ezkzey8FWoEnnHHP4rxbrysJqoMmzwR2EdoD5p7FDsF64qxbQ", 1],
      ["STM7TCZKisQnvR69CK9BaL6W4SJn2cXYwkfWYRicoVGGzhtFswxMH", 1]]},
  "active"=>
   {"weight_threshold"=>1,
    "account_auths"=>[],
    "key_auths"=>
     [["STM5VkLha96X5EQu3HSkJdD8SEuwazWtZrzLjUT6Sc5sopgghBYrz", 1],
      ["STM7u1BsoqLaoCu9XHi1wjWctLWSFCuvyagFjYMfga4QNWEjP7d3U", 1]]},
  "posting"=>
   {"weight_threshold"=>1,
    "account_auths"=>[],
    "key_auths"=>
     [["STM6kXdRbWgoH9E4hvtTZeaiSbY8FmGXQavfJZ2jzkKjT5cWYgMBS", 1],
      ["STM6tDMSSKa8Bd9ss7EjqhXPEHTWissGXJJosAU94LLpC5tsCdo61", 1]]},
  "memo_key"=>"STM5jZtLoV8YbxCxr4imnbWn61zMB24wwonpnVhfXRmv7j6fk3dTH",
  "json_metadata"=>"",
  "proxy"=>"",
  "last_owner_update"=>"2018-05-31T23:32:06",
  "last_account_update"=>"2018-05-31T23:32:06",
  "created"=>"2016-03-24T17:00:21",
  "mined"=>true,
  "recovery_account"=>"steem",
  "last_account_recovery"=>"1970-01-01T00:00:00",
  "reset_account"=>"null",
  "comment_count"=>0,
  "lifetime_vote_count"=>0,
  "post_count"=>1,
  "can_vote"=>true,
  "voting_manabar"=>
   {"current_mana"=>"84785778120382011", "last_update_time"=>1547781042},
  "balance"=>{"amount"=>"2", "precision"=>3, "nai"=>"@@000000021"},
  "savings_balance"=>{"amount"=>"0", "precision"=>3, "nai"=>"@@000000021"},
  "sbd_balance"=>{"amount"=>"8716549", "precision"=>3, "nai"=>"@@000000013"},
  "sbd_seconds"=>"7108510241427",
  "sbd_seconds_last_update"=>"2019-01-22T14:09:18",
  "sbd_last_interest_payment"=>"2019-01-13T03:37:18",
  "savings_sbd_balance"=>{"amount"=>"0", "precision"=>3, "nai"=>"@@000000013"},
  "savings_sbd_seconds"=>"0",
  "savings_sbd_seconds_last_update"=>"1970-01-01T00:00:00",
  "savings_sbd_last_interest_payment"=>"1970-01-01T00:00:00",
  "savings_withdraw_requests"=>0,
  "reward_sbd_balance"=>{"amount"=>"1", "precision"=>3, "nai"=>"@@000000013"},
  "reward_steem_balance"=>
   {"amount"=>"359", "precision"=>3, "nai"=>"@@000000021"},
  "reward_vesting_balance"=>
   {"amount"=>"730389810", "precision"=>6, "nai"=>"@@000000037"},
  "reward_vesting_steem"=>
   {"amount"=>"363", "precision"=>3, "nai"=>"@@000000021"},
  "vesting_shares"=>
   {"amount"=>"84785778120382011", "precision"=>6, "nai"=>"@@000000037"},
  "delegated_vesting_shares"=>
   {"amount"=>"0", "precision"=>6, "nai"=>"@@000000037"},
  "received_vesting_shares"=>
   {"amount"=>"0", "precision"=>6, "nai"=>"@@000000037"},
  "vesting_withdraw_rate"=>
   {"amount"=>"6505147286153846", "precision"=>6, "nai"=>"@@000000037"},
  "next_vesting_withdrawal"=>"2019-01-27T05:34:06",
  "withdrawn"=>0,
  "to_withdraw"=>"84566914720000000",
  "withdraw_routes"=>4,
  "curation_rewards"=>0,
  "posting_rewards"=>3548,
  "proxied_vsf_votes"=>["14511431797", 0, 0, 0],
  "witnesses_voted_for"=>0,
  "last_post"=>"2016-03-30T18:30:18",
  "last_root_post"=>"2016-03-30T18:30:18",
  "last_vote_time"=>"2016-12-04T23:10:57",
  "post_bandwidth"=>0,
  "pending_claimed_accounts"=>0,
  "is_smt"=>false}]
```

## Steem-Print-Accounts.rb using radiator

Next I show you how to get the account informations using radiator. I called the script `[Steem-Print-Accounts.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Sources/Steem-Print-Accounts.rb)` as the output is more high level.  Check out the comments in the sample code for details. The one thing I would like to point it the use of an error attribute for error handling which is a bit awkward to use and leads to a rather ugly `Result.result` construct.

Check out the comments in the sample code for more details.

```Ruby
#!/opt/local/bin/ruby

# use the steem.rb file from the radiator gem. This is only needed if you have
# both steem-api and radiator installed.

gem "radiator", :require => "steem"

require 'pp'
require 'colorize'
require 'radiator'

if ARGV.length == 0 then
   puts """
Steem-Print-Accounts — Print account infos from Steem database

Usage:
   Steem-Print-Accounts accountname …

"""
else
   # read arguments from command line

   Account_Names = ARGV

   # create instance to the steem database API

   Database_Api = Radiator::DatabaseApi.new

   # request account informations from the steem database and print out
   # the accounts found using pretty print (pp) or print out error
   # informations when an error occurred.

   Result = Database_Api.get_accounts(Account_Names)

   if Result.key?('error') then
      puts "Error reading accounts:".red
      pp Result.error
   elsif Result.result.length == 0 then
      puts "No accounts found.".yellow
   else
      pp Result.result
   end
end
```

The output of the command (for the steemit account) looks like this. Do note how all the balances are reformatted to be human readable and that there are 10 additional attributes at the end.

```
>ruby Steem-Print-Accounts.rb steemit
[{"id"=>28,
  "name"=>"steemit",
  "owner"=>
   {"weight_threshold"=>1,
    "account_auths"=>[],
    "key_auths"=>
     [["STM6Ezkzey8FWoEnnHHP4rxbrysJqoMmzwR2EdoD5p7FDsF64qxbQ", 1],
      ["STM7TCZKisQnvR69CK9BaL6W4SJn2cXYwkfWYRicoVGGzhtFswxMH", 1]]},
  "active"=>
   {"weight_threshold"=>1,
    "account_auths"=>[],
    "key_auths"=>
     [["STM5VkLha96X5EQu3HSkJdD8SEuwazWtZrzLjUT6Sc5sopgghBYrz", 1],
      ["STM7u1BsoqLaoCu9XHi1wjWctLWSFCuvyagFjYMfga4QNWEjP7d3U", 1]]},
  "posting"=>
   {"weight_threshold"=>1,
    "account_auths"=>[],
    "key_auths"=>
     [["STM6kXdRbWgoH9E4hvtTZeaiSbY8FmGXQavfJZ2jzkKjT5cWYgMBS", 1],
      ["STM6tDMSSKa8Bd9ss7EjqhXPEHTWissGXJJosAU94LLpC5tsCdo61", 1]]},
  "memo_key"=>"STM5jZtLoV8YbxCxr4imnbWn61zMB24wwonpnVhfXRmv7j6fk3dTH",
  "json_metadata"=>"",
  "proxy"=>"",
  "last_owner_update"=>"2018-05-31T23:32:06",
  "last_account_update"=>"2018-05-31T23:32:06",
  "created"=>"2016-03-24T17:00:21",
  "mined"=>true,
  "recovery_account"=>"steem",
  "last_account_recovery"=>"1970-01-01T00:00:00",
  "reset_account"=>"null",
  "comment_count"=>0,
  "lifetime_vote_count"=>0,
  "post_count"=>1,
  "can_vote"=>true,
  "voting_manabar"=>
   {"current_mana"=>"84785778120382011", "last_update_time"=>1547781042},
  "voting_power"=>0,
  "balance"=>"0.002 STEEM",
  "savings_balance"=>"0.000 STEEM",
  "sbd_balance"=>"8716.549 SBD",
  "sbd_seconds"=>"7108510241427",
  "sbd_seconds_last_update"=>"2019-01-22T14:09:18",
  "sbd_last_interest_payment"=>"2019-01-13T03:37:18",
  "savings_sbd_balance"=>"0.000 SBD",
  "savings_sbd_seconds"=>"0",
  "savings_sbd_seconds_last_update"=>"1970-01-01T00:00:00",
  "savings_sbd_last_interest_payment"=>"1970-01-01T00:00:00",
  "savings_withdraw_requests"=>0,
  "reward_sbd_balance"=>"0.001 SBD",
  "reward_steem_balance"=>"0.359 STEEM",
  "reward_vesting_balance"=>"730.389810 VESTS",
  "reward_vesting_steem"=>"0.363 STEEM",
  "vesting_shares"=>"84785778120.382011 VESTS",
  "delegated_vesting_shares"=>"0.000000 VESTS",
  "received_vesting_shares"=>"0.000000 VESTS",
  "vesting_withdraw_rate"=>"6505147286.153846 VESTS",
  "next_vesting_withdrawal"=>"2019-01-27T05:34:06",
  "withdrawn"=>0,
  "to_withdraw"=>"84566914720000000",
  "withdraw_routes"=>4,
  "curation_rewards"=>0,
  "posting_rewards"=>3548,
  "proxied_vsf_votes"=>["14511431797", 0, 0, 0],
  "witnesses_voted_for"=>0,
  "last_post"=>"2016-03-30T18:30:18",
  "last_root_post"=>"2016-03-30T18:30:18",
  "last_vote_time"=>"2016-12-04T23:10:57",
  "post_bandwidth"=>0,
  "pending_claimed_accounts"=>0,
  "vesting_balance"=>"0.000 STEEM",
  "reputation"=>"12944616889",
  "transfer_history"=>[],
  "market_history"=>[],
  "post_history"=>[],
  "vote_history"=>[],
  "other_history"=>[],
  "witness_votes"=>[],
  "tags_usage"=>[],
  "guest_bloggers"=>[]}]
```

# Curriculum


## First tutorial

[Using Steem-API with Ruby Part 1](https://busy.org/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

[Using Steem-API with Ruby Part 1](https://busy.org/@krischik/using-steem-api-with-ruby-part-1)

## Proof of Work Done

https://github.com/krischik/SteemRubyTutorial

<center> ![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png) </center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
