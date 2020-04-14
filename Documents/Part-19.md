# Using Steem-API with Ruby Part 19 — Access Hive Blockchain 1

ruby hive hive-api steem-api programming tutorials palnet marlians stem neoxian 

<center>![Hive_Steem_Ruby_Engine.png](https://files.peakd.com/file/peakd-hive/krischik/ve2qoADQ-Hive_Steem_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-Config.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Config.rb)
* radiator sample code: [Steem-Print-Config.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Config.rb).

### steem-ruby

* Project Name: Steem Ruby (with Hive patches)
* Repository: [https://github.com/krischik/steem-ruby](https://github.com/krischik/steem-ruby)
* Official Documentation: [https://www.rubydoc.info/gems/steem-ruby](https://www.rubydoc.info/gems/steem-ruby)
* Official Tutorial: N/A

### radiator

* Project Name: Radiator (with Hive patches)
* Repository: [https://github.com/krischik/radiator](https://github.com/krischik/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

## What Will I Learn?

This tutorial shows how to interact with the Steem and Hive blockchain as well as the Steem and Hive database using Ruby. When using Ruby you have three APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages sample code for both APIs will be provided so the reader ca decide which is more suitable.

In this chapter of the tutorial you learn how to write scripts which will run both on the Steem and Hive blockchain using the printing the chain configuration as example.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following standard ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
```

For Hive compatibility you need the hive patched versions of the `steem-ruby` and `radiator` ruby gems. These are not yet available in the standard ruby gem repository and you need to install them from source. For this you change into the directory you keep Git clones and use the following commands:

```sh
git clone "https://github.com/krischik/steem-ruby"

pushd "steem-ruby"
    git checkout feature/Enhancement22
    gem build "steem-ruby.gemspec"
    gem install "steem-ruby"
popd 

git clone "https://github.com/krischik/radiator"

pushd "radiator" 
    git checkout feature/Enhancement22
    gem build "radiator.gemspec"
    gem install "radiator"
popd 
```

**Note:** All APIs steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When more then one APIs is installed ruby must be told which one to use.
2. The tree APIs can't be used in the same script.

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

The Hive blockchain is mostly identical to the steem blockchain. The main difference is the new URL to interact with the chain and new names for the token. Chain id, chain prefix and NAIs stayed the same.

While it is possible the specify the chain URL when instantiating the API classes it is not possible to specify then names of the token. It was therefore necessary the change the **steem-api** and **radiator** source. I will not go into details on how this is done. If you are an advanced user who is interested i suggest you compare the sources on GitHub. I have added a helpful `without-hive` tag as reference.

To make accessing Hive as easy as possible I added a new `:hive` symbolic chain id. All you need to do to use Hive is set the when instantiating an API classed.

Instead of:

```ruby
   Condenser_Api = Steem::CondenserApi.new
```

you now call:

```ruby
   Condenser_Api = Steem::CondenserApi.new({chain: :hive})
```

There is also a `:test` and `:steem` chain for the steem test chain and steem main chain.

Since every script will need to run with both chains I added a little `Chain` utility script to setup select the chain via environment variables. That's fine for scripts but if you write full features applications you need to think of different techniques. 

## Implementation using steem-ruby

### Utility script Chain.rb

Use the "steem.rb" file from the steem-ruby gem. This is only needed if you have both **steem-api** and **radiator** installed.

```ruby
gem "steem-ruby", :require => "steem"

require 'steem'
```

Read the `CHAIN_ID` environment variable and  initialise the `Chain_Options` constant with parameters suitable for the chain requested.

```ruby
case ENV["CHAIN_ID"]&.downcase
   when "test"
      Chain_Options = {
	 chain:         :test,
	 failover_urls: [
	    Steem::ChainConfig::NETWORKS_TEST_DEFAULT_NODE
	 ]
      }
   when "hive"
      Chain_Options = {
	 chain:         :hive,
	 failover_urls: [
	    Steem::ChainConfig::NETWORKS_HIVE_DEFAULT_NODE
	 ]
      }
   else
      Chain_Options = {}
end
```

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Scripts/Steem/Chain.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem/Chain.rb).

### Main script Steem-Dump-Config.rb

initialize access to the steem or hive blockchain.  The script will initialize the constant Chain_Options with suitable parameter for the chain selected with the  `CHAIN_ID` environment variable.
 
```ruby
require_relative 'Steem/Chain'

begin
```
create instance to the steem condenser API which will give us access to

```ruby
   Condenser_Api = Steem::CondenserApi.new Chain_Options
```

read the chain configuration. Yes, it's as simple as this.

```ruby
   Chain_Configuration = Condenser_Api.get_config
rescue => error
```
I am using Kernel::abort so the code snipped including error handler can be copy pasted into other scripts

```ruby
   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

pretty print the result. It might look strange to do so outside the begin / rescue but the value is now available in constant for the rest of the script. Do note that using constant is only suitable for short running script.  Long running scripts would need to re-read the value on a regular basis.

```ruby
pp Chain_Configuration
```

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Config.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Config.rb).

The output of the command (for the hive blockchain) looks like this:

```sh
>CHAIN_ID=hive Scripts/Steem-Dump-Config.rb
{"jsonrpc"=>"2.0",
 "result"=>
  {"IS_TEST_NET"=>false,
   "HIVE_ENABLE_SMT"=>false,
   "HBD_SYMBOL"=>{"nai"=>"@@000000013", "decimals"=>3},
   "HIVE_INITIAL_VOTE_POWER_RATE"=>40,
   "HIVE_REDUCED_VOTE_POWER_RATE"=>10,
   "HIVE_100_PERCENT"=>10000,
   "HIVE_1_PERCENT"=>100,
   "HIVE_ACCOUNT_RECOVERY_REQUEST_EXPIRATION_PERIOD"=>"86400000000",
   "HIVE_ACTIVE_CHALLENGE_COOLDOWN"=>"86400000000",
   "HIVE_ACTIVE_CHALLENGE_FEE"=>
    {"amount"=>"2000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_ADDRESS_PREFIX"=>"STM",
   "HIVE_APR_PERCENT_MULTIPLY_PER_BLOCK"=>"102035135585887",
   "HIVE_APR_PERCENT_MULTIPLY_PER_HOUR"=>"119577151364285",
   "HIVE_APR_PERCENT_MULTIPLY_PER_ROUND"=>"133921203762304",
   "HIVE_APR_PERCENT_SHIFT_PER_BLOCK"=>87,
   "HIVE_APR_PERCENT_SHIFT_PER_HOUR"=>77,
   "HIVE_APR_PERCENT_SHIFT_PER_ROUND"=>83,
   "HIVE_BANDWIDTH_AVERAGE_WINDOW_SECONDS"=>604800,
   "HIVE_BANDWIDTH_PRECISION"=>1000000,
   "HIVE_BENEFICIARY_LIMIT"=>128,
   "HIVE_BLOCKCHAIN_PRECISION"=>1000,
   "HIVE_BLOCKCHAIN_PRECISION_DIGITS"=>3,
   "HIVE_BLOCKCHAIN_HARDFORK_VERSION"=>"0.23.0",
   "HIVE_BLOCKCHAIN_VERSION"=>"0.23.0",
   "HIVE_BLOCK_INTERVAL"=>3,
   "HIVE_BLOCKS_PER_DAY"=>28800,
   "HIVE_BLOCKS_PER_HOUR"=>1200,
   "HIVE_BLOCKS_PER_YEAR"=>10512000,
   "HIVE_CASHOUT_WINDOW_SECONDS"=>604800,
   "HIVE_CASHOUT_WINDOW_SECONDS_PRE_HF12"=>86400,
   "HIVE_CASHOUT_WINDOW_SECONDS_PRE_HF17"=>43200,
   "HIVE_CHAIN_ID"=>
    "0000000000000000000000000000000000000000000000000000000000000000",
   "HIVE_COMMENT_REWARD_FUND_NAME"=>"comment",
   "HIVE_COMMENT_TITLE_LIMIT"=>256,
   "HIVE_CONTENT_APR_PERCENT"=>3875,
   "HIVE_CONTENT_CONSTANT_HF0"=>"2000000000000",
   "HIVE_CONTENT_CONSTANT_HF21"=>"2000000000000",
   "HIVE_CONTENT_REWARD_PERCENT_HF16"=>7500,
   "HIVE_CONTENT_REWARD_PERCENT_HF21"=>6500,
   "HIVE_CONVERSION_DELAY"=>"302400000000",
   "HIVE_CONVERSION_DELAY_PRE_HF_16"=>"604800000000",
   "HIVE_CREATE_ACCOUNT_DELEGATION_RATIO"=>5,
   "HIVE_CREATE_ACCOUNT_DELEGATION_TIME"=>"2592000000000",
   "HIVE_CREATE_ACCOUNT_WITH_HIVE_MODIFIER"=>30,
   "HIVE_CURATE_APR_PERCENT"=>3875,
   "HIVE_CUSTOM_OP_DATA_MAX_LENGTH"=>8192,
   "HIVE_CUSTOM_OP_ID_MAX_LENGTH"=>32,
   "HIVE_DEFAULT_HBD_INTEREST_RATE"=>1000,
   "HIVE_DOWNVOTE_POOL_PERCENT_HF21"=>2500,
   "HIVE_EQUIHASH_K"=>6,
   "HIVE_EQUIHASH_N"=>140,
   "HIVE_FEED_HISTORY_WINDOW"=>84,
   "HIVE_FEED_HISTORY_WINDOW_PRE_HF_16"=>168,
   "HIVE_FEED_INTERVAL_BLOCKS"=>1200,
   "HIVE_GENESIS_TIME"=>"2016-03-24T16:00:00",
   "HIVE_HARDFORK_REQUIRED_WITNESSES"=>17,
   "HIVE_HF21_CONVERGENT_LINEAR_RECENT_CLAIMS"=>"503600561838938636",
   "HIVE_INFLATION_NARROWING_PERIOD"=>250000,
   "HIVE_INFLATION_RATE_START_PERCENT"=>978,
   "HIVE_INFLATION_RATE_STOP_PERCENT"=>95,
   "HIVE_INIT_MINER_NAME"=>"initminer",
   "HIVE_INIT_PUBLIC_KEY_STR"=>
    "STM8GC13uCZbP44HzMLV6zPZGwVQ8Nt4Kji8PapsPiNq1BK153XTX",
   "HIVE_INIT_SUPPLY"=>0,
   "HIVE_HBD_INIT_SUPPLY"=>0,
   "HIVE_INIT_TIME"=>"1970-01-01T00:00:00",
   "HIVE_IRREVERSIBLE_THRESHOLD"=>7500,
   "HIVE_LIQUIDITY_APR_PERCENT"=>750,
   "HIVE_LIQUIDITY_REWARD_BLOCKS"=>1200,
   "HIVE_LIQUIDITY_REWARD_PERIOD_SEC"=>3600,
   "HIVE_LIQUIDITY_TIMEOUT_SEC"=>"604800000000",
   "HIVE_MAX_ACCOUNT_CREATION_FEE"=>1000000000,
   "HIVE_MAX_ACCOUNT_NAME_LENGTH"=>16,
   "HIVE_MAX_ACCOUNT_WITNESS_VOTES"=>30,
   "HIVE_MAX_ASSET_WHITELIST_AUTHORITIES"=>10,
   "HIVE_MAX_AUTHORITY_MEMBERSHIP"=>40,
   "HIVE_MAX_BLOCK_SIZE"=>393216000,
   "HIVE_SOFT_MAX_BLOCK_SIZE"=>2097152,
   "HIVE_MAX_CASHOUT_WINDOW_SECONDS"=>1209600,
   "HIVE_MAX_COMMENT_DEPTH"=>65535,
   "HIVE_MAX_COMMENT_DEPTH_PRE_HF17"=>6,
   "HIVE_MAX_FEED_AGE_SECONDS"=>604800,
   "HIVE_MAX_INSTANCE_ID"=>"281474976710655",
   "HIVE_MAX_MEMO_SIZE"=>2048,
   "HIVE_MAX_WITNESSES"=>21,
   "HIVE_MAX_MINER_WITNESSES_HF0"=>1,
   "HIVE_MAX_MINER_WITNESSES_HF17"=>0,
   "HIVE_MAX_PERMLINK_LENGTH"=>256,
   "HIVE_MAX_PROXY_RECURSION_DEPTH"=>4,
   "HIVE_MAX_RATION_DECAY_RATE"=>1000000,
   "HIVE_MAX_RESERVE_RATIO"=>20000,
   "HIVE_MAX_RUNNER_WITNESSES_HF0"=>1,
   "HIVE_MAX_RUNNER_WITNESSES_HF17"=>1,
   "HIVE_MAX_SATOSHIS"=>"4611686018427387903",
   "HIVE_MAX_SHARE_SUPPLY"=>"1000000000000000",
   "HIVE_MAX_SIG_CHECK_DEPTH"=>2,
   "HIVE_MAX_SIG_CHECK_ACCOUNTS"=>125,
   "HIVE_MAX_TIME_UNTIL_EXPIRATION"=>3600,
   "HIVE_MAX_TRANSACTION_SIZE"=>65536,
   "HIVE_MAX_UNDO_HISTORY"=>10000,
   "HIVE_MAX_URL_LENGTH"=>127,
   "HIVE_MAX_VOTE_CHANGES"=>5,
   "HIVE_MAX_VOTED_WITNESSES_HF0"=>19,
   "HIVE_MAX_VOTED_WITNESSES_HF17"=>20,
   "HIVE_MAX_WITHDRAW_ROUTES"=>10,
   "HIVE_MAX_WITNESS_URL_LENGTH"=>2048,
   "HIVE_MIN_ACCOUNT_CREATION_FEE"=>1,
   "HIVE_MIN_ACCOUNT_NAME_LENGTH"=>3,
   "HIVE_MIN_BLOCK_SIZE_LIMIT"=>65536,
   "HIVE_MIN_BLOCK_SIZE"=>115,
   "HIVE_MIN_CONTENT_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_MIN_CURATE_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_MIN_PERMLINK_LENGTH"=>0,
   "HIVE_MIN_REPLY_INTERVAL"=>20000000,
   "HIVE_MIN_REPLY_INTERVAL_HF20"=>3000000,
   "HIVE_MIN_ROOT_COMMENT_INTERVAL"=>300000000,
   "HIVE_MIN_COMMENT_EDIT_INTERVAL"=>3000000,
   "HIVE_MIN_VOTE_INTERVAL_SEC"=>3,
   "HIVE_MINER_ACCOUNT"=>"miners",
   "HIVE_MINER_PAY_PERCENT"=>100,
   "HIVE_MIN_FEEDS"=>7,
   "HIVE_MINING_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_MINING_TIME"=>"2016-03-24T17:00:00",
   "HIVE_MIN_LIQUIDITY_REWARD"=>
    {"amount"=>"1200000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_MIN_LIQUIDITY_REWARD_PERIOD_SEC"=>60000000,
   "HIVE_MIN_PAYOUT_HBD"=>
    {"amount"=>"20", "precision"=>3, "nai"=>"@@000000013"},
   "HIVE_MIN_POW_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_MIN_PRODUCER_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_MIN_TRANSACTION_EXPIRATION_LIMIT"=>15,
   "HIVE_MIN_TRANSACTION_SIZE_LIMIT"=>1024,
   "HIVE_MIN_UNDO_HISTORY"=>10,
   "HIVE_NULL_ACCOUNT"=>"null",
   "HIVE_NUM_INIT_MINERS"=>1,
   "HIVE_OWNER_AUTH_HISTORY_TRACKING_START_BLOCK_NUM"=>3186477,
   "HIVE_OWNER_AUTH_RECOVERY_PERIOD"=>"2592000000000",
   "HIVE_OWNER_CHALLENGE_COOLDOWN"=>"86400000000",
   "HIVE_OWNER_CHALLENGE_FEE"=>
    {"amount"=>"30000", "precision"=>3, "nai"=>"@@000000021"},
   "HIVE_OWNER_UPDATE_LIMIT"=>3600000000,
   "HIVE_POST_AVERAGE_WINDOW"=>86400,
   "HIVE_POST_REWARD_FUND_NAME"=>"post",
   "HIVE_POST_WEIGHT_CONSTANT"=>1600000000,
   "HIVE_POW_APR_PERCENT"=>750,
   "HIVE_PRODUCER_APR_PERCENT"=>750,
   "HIVE_PROXY_TO_SELF_ACCOUNT"=>"",
   "HIVE_SBD_INTEREST_COMPOUND_INTERVAL_SEC"=>2592000,
   "HIVE_SECONDS_PER_YEAR"=>31536000,
   "HIVE_PROPOSAL_FUND_PERCENT_HF0"=>0,
   "HIVE_PROPOSAL_FUND_PERCENT_HF21"=>1000,
   "HIVE_RECENT_RSHARES_DECAY_TIME_HF19"=>"1296000000000",
   "HIVE_RECENT_RSHARES_DECAY_TIME_HF17"=>"2592000000000",
   "HIVE_REVERSE_AUCTION_WINDOW_SECONDS_HF6"=>1800,
   "HIVE_REVERSE_AUCTION_WINDOW_SECONDS_HF20"=>900,
   "HIVE_REVERSE_AUCTION_WINDOW_SECONDS_HF21"=>300,
   "HIVE_ROOT_POST_PARENT"=>"",
   "HIVE_SAVINGS_WITHDRAW_REQUEST_LIMIT"=>100,
   "HIVE_SAVINGS_WITHDRAW_TIME"=>"259200000000",
   "HIVE_HBD_START_PERCENT_HF14"=>200,
   "HIVE_HBD_START_PERCENT_HF20"=>900,
   "HIVE_HBD_STOP_PERCENT_HF14"=>500,
   "HIVE_HBD_STOP_PERCENT_HF20"=>1000,
   "HIVE_SECOND_CASHOUT_WINDOW"=>2592000,
   "HIVE_SOFT_MAX_COMMENT_DEPTH"=>255,
   "HIVE_START_MINER_VOTING_BLOCK"=>864000,
   "HIVE_START_VESTING_BLOCK"=>201600,
   "HIVE_TEMP_ACCOUNT"=>"temp",
   "HIVE_UPVOTE_LOCKOUT_HF7"=>60000000,
   "HIVE_UPVOTE_LOCKOUT_HF17"=>"43200000000",
   "HIVE_UPVOTE_LOCKOUT_SECONDS"=>43200,
   "HIVE_VESTING_FUND_PERCENT_HF16"=>1500,
   "HIVE_VESTING_WITHDRAW_INTERVALS"=>13,
   "HIVE_VESTING_WITHDRAW_INTERVALS_PRE_HF_16"=>104,
   "HIVE_VESTING_WITHDRAW_INTERVAL_SECONDS"=>604800,
   "HIVE_VOTE_DUST_THRESHOLD"=>50000000,
   "HIVE_VOTING_MANA_REGENERATION_SECONDS"=>432000,
   "HIVE_SYMBOL"=>{"nai"=>"@@000000021", "decimals"=>3},
   "VESTS_SYMBOL"=>{"nai"=>"@@000000037", "decimals"=>6},
   "HIVE_VIRTUAL_SCHEDULE_LAP_LENGTH"=>"18446744073709551615",
   "HIVE_VIRTUAL_SCHEDULE_LAP_LENGTH2"=>
    "340282366920938463463374607431768211455",
   "HIVE_MAX_LIMIT_ORDER_EXPIRATION"=>2419200,
   "HIVE_DELEGATION_RETURN_PERIOD_HF0"=>604800,
   "HIVE_DELEGATION_RETURN_PERIOD_HF20"=>432000,
   "HIVE_RD_MIN_DECAY_BITS"=>6,
   "HIVE_RD_MAX_DECAY_BITS"=>32,
   "HIVE_RD_DECAY_DENOM_SHIFT"=>36,
   "HIVE_RD_MAX_POOL_BITS"=>64,
   "HIVE_RD_MAX_BUDGET_1"=>"17179869183",
   "HIVE_RD_MAX_BUDGET_2"=>268435455,
   "HIVE_RD_MAX_BUDGET_3"=>2147483647,
   "HIVE_RD_MAX_BUDGET"=>268435455,
   "HIVE_RD_MIN_DECAY"=>64,
   "HIVE_RD_MIN_BUDGET"=>1,
   "HIVE_RD_MAX_DECAY"=>4294967295,
   "HIVE_ACCOUNT_SUBSIDY_PRECISION"=>10000,
   "HIVE_WITNESS_SUBSIDY_BUDGET_PERCENT"=>12500,
   "HIVE_WITNESS_SUBSIDY_DECAY_PERCENT"=>210000,
   "HIVE_DEFAULT_ACCOUNT_SUBSIDY_DECAY"=>347321,
   "HIVE_DEFAULT_ACCOUNT_SUBSIDY_BUDGET"=>797,
   "HIVE_DECAY_BACKSTOP_PERCENT"=>9000,
   "HIVE_BLOCK_GENERATION_POSTPONED_TX_LIMIT"=>5,
   "HIVE_PENDING_TRANSACTION_EXECUTION_LIMIT"=>200000,
   "HIVE_TREASURY_ACCOUNT"=>"steem.dao",
   "HIVE_TREASURY_FEE"=>10000,
   "HIVE_PROPOSAL_MAINTENANCE_PERIOD"=>3600,
   "HIVE_PROPOSAL_MAINTENANCE_CLEANUP"=>86400,
   "HIVE_PROPOSAL_SUBJECT_MAX_LENGTH"=>80,
   "HIVE_PROPOSAL_MAX_IDS_NUMBER"=>5},
 "id"=>2}
```

## Implementation using radiator

The radiator implementation is identical to the steem implementation apart from using **radiator** instead of **steem-api**. 

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Config.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Config.rb).

The output of the command (for the steem blockchain) looks identical to the previous output:

```sh
>CHAIN_ID=steem Scripts/Steem-Print-Config.rb                   
{"jsonrpc"=>"2.0",
 "result"=>
  {"IS_TEST_NET"=>false,
   "STEEM_ENABLE_SMT"=>false,
   "SBD_SYMBOL"=>{"nai"=>"@@000000013", "decimals"=>3},
   "STEEM_INITIAL_VOTE_POWER_RATE"=>40,
   "STEEM_REDUCED_VOTE_POWER_RATE"=>10,
   "STEEM_100_PERCENT"=>10000,
   "STEEM_1_PERCENT"=>100,
   "STEEM_ACCOUNT_RECOVERY_REQUEST_EXPIRATION_PERIOD"=>"86400000000",
   "STEEM_ACTIVE_CHALLENGE_COOLDOWN"=>"86400000000",
   "STEEM_ACTIVE_CHALLENGE_FEE"=>
    {"amount"=>"2000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_ADDRESS_PREFIX"=>"STM",
   "STEEM_APR_PERCENT_MULTIPLY_PER_BLOCK"=>"102035135585887",
   "STEEM_APR_PERCENT_MULTIPLY_PER_HOUR"=>"119577151364285",
   "STEEM_APR_PERCENT_MULTIPLY_PER_ROUND"=>"133921203762304",
   "STEEM_APR_PERCENT_SHIFT_PER_BLOCK"=>87,
   "STEEM_APR_PERCENT_SHIFT_PER_HOUR"=>77,
   "STEEM_APR_PERCENT_SHIFT_PER_ROUND"=>83,
   "STEEM_BANDWIDTH_AVERAGE_WINDOW_SECONDS"=>604800,
   "STEEM_BANDWIDTH_PRECISION"=>1000000,
   "STEEM_BENEFICIARY_LIMIT"=>128,
   "STEEM_BLOCKCHAIN_PRECISION"=>1000,
   "STEEM_BLOCKCHAIN_PRECISION_DIGITS"=>3,
   "STEEM_BLOCKCHAIN_HARDFORK_VERSION"=>"0.22.0",
   "STEEM_BLOCKCHAIN_VERSION"=>"0.22.1",
   "STEEM_BLOCK_INTERVAL"=>3,
   "STEEM_BLOCKS_PER_DAY"=>28800,
   "STEEM_BLOCKS_PER_HOUR"=>1200,
   "STEEM_BLOCKS_PER_YEAR"=>10512000,
   "STEEM_CASHOUT_WINDOW_SECONDS"=>604800,
   "STEEM_CASHOUT_WINDOW_SECONDS_PRE_HF12"=>86400,
   "STEEM_CASHOUT_WINDOW_SECONDS_PRE_HF17"=>43200,
   "STEEM_CHAIN_ID"=>
    "0000000000000000000000000000000000000000000000000000000000000000",
   "STEEM_COMMENT_REWARD_FUND_NAME"=>"comment",
   "STEEM_COMMENT_TITLE_LIMIT"=>256,
   "STEEM_CONTENT_APR_PERCENT"=>3875,
   "STEEM_CONTENT_CONSTANT_HF0"=>"2000000000000",
   "STEEM_CONTENT_CONSTANT_HF21"=>"2000000000000",
   "STEEM_CONTENT_REWARD_PERCENT_HF16"=>7500,
   "STEEM_CONTENT_REWARD_PERCENT_HF21"=>6500,
   "STEEM_CONVERSION_DELAY"=>"302400000000",
   "STEEM_CONVERSION_DELAY_PRE_HF_16"=>"604800000000",
   "STEEM_CREATE_ACCOUNT_DELEGATION_RATIO"=>5,
   "STEEM_CREATE_ACCOUNT_DELEGATION_TIME"=>"2592000000000",
   "STEEM_CREATE_ACCOUNT_WITH_STEEM_MODIFIER"=>30,
   "STEEM_CURATE_APR_PERCENT"=>3875,
   "STEEM_CUSTOM_OP_DATA_MAX_LENGTH"=>8192,
   "STEEM_CUSTOM_OP_ID_MAX_LENGTH"=>32,
   "STEEM_DEFAULT_SBD_INTEREST_RATE"=>1000,
   "STEEM_DOWNVOTE_POOL_PERCENT_HF21"=>2500,
   "STEEM_EQUIHASH_K"=>6,
   "STEEM_EQUIHASH_N"=>140,
   "STEEM_FEED_HISTORY_WINDOW"=>84,
   "STEEM_FEED_HISTORY_WINDOW_PRE_HF_16"=>168,
   "STEEM_FEED_INTERVAL_BLOCKS"=>1200,
   "STEEM_GENESIS_TIME"=>"2016-03-24T16:00:00",
   "STEEM_HARDFORK_REQUIRED_WITNESSES"=>17,
   "STEEM_HF21_CONVERGENT_LINEAR_RECENT_CLAIMS"=>"503600561838938636",
   "STEEM_INFLATION_NARROWING_PERIOD"=>250000,
   "STEEM_INFLATION_RATE_START_PERCENT"=>978,
   "STEEM_INFLATION_RATE_STOP_PERCENT"=>95,
   "STEEM_INIT_MINER_NAME"=>"initminer",
   "STEEM_INIT_PUBLIC_KEY_STR"=>
    "STM8GC13uCZbP44HzMLV6zPZGwVQ8Nt4Kji8PapsPiNq1BK153XTX",
   "STEEM_INIT_SUPPLY"=>0,
   "STEEM_SBD_INIT_SUPPLY"=>0,
   "STEEM_INIT_TIME"=>"1970-01-01T00:00:00",
   "STEEM_IRREVERSIBLE_THRESHOLD"=>7500,
   "STEEM_LIQUIDITY_APR_PERCENT"=>750,
   "STEEM_LIQUIDITY_REWARD_BLOCKS"=>1200,
   "STEEM_LIQUIDITY_REWARD_PERIOD_SEC"=>3600,
   "STEEM_LIQUIDITY_TIMEOUT_SEC"=>"604800000000",
   "STEEM_MAX_ACCOUNT_CREATION_FEE"=>1000000000,
   "STEEM_MAX_ACCOUNT_NAME_LENGTH"=>16,
   "STEEM_MAX_ACCOUNT_WITNESS_VOTES"=>30,
   "STEEM_MAX_ASSET_WHITELIST_AUTHORITIES"=>10,
   "STEEM_MAX_AUTHORITY_MEMBERSHIP"=>40,
   "STEEM_MAX_BLOCK_SIZE"=>393216000,
   "STEEM_SOFT_MAX_BLOCK_SIZE"=>2097152,
   "STEEM_MAX_CASHOUT_WINDOW_SECONDS"=>1209600,
   "STEEM_MAX_COMMENT_DEPTH"=>65535,
   "STEEM_MAX_COMMENT_DEPTH_PRE_HF17"=>6,
   "STEEM_MAX_FEED_AGE_SECONDS"=>604800,
   "STEEM_MAX_INSTANCE_ID"=>"281474976710655",
   "STEEM_MAX_MEMO_SIZE"=>2048,
   "STEEM_MAX_WITNESSES"=>21,
   "STEEM_MAX_MINER_WITNESSES_HF0"=>1,
   "STEEM_MAX_MINER_WITNESSES_HF17"=>0,
   "STEEM_MAX_PERMLINK_LENGTH"=>256,
   "STEEM_MAX_PROXY_RECURSION_DEPTH"=>4,
   "STEEM_MAX_RATION_DECAY_RATE"=>1000000,
   "STEEM_MAX_RESERVE_RATIO"=>20000,
   "STEEM_MAX_RUNNER_WITNESSES_HF0"=>1,
   "STEEM_MAX_RUNNER_WITNESSES_HF17"=>1,
   "STEEM_MAX_SATOSHIS"=>"4611686018427387903",
   "STEEM_MAX_SHARE_SUPPLY"=>"1000000000000000",
   "STEEM_MAX_SIG_CHECK_DEPTH"=>2,
   "STEEM_MAX_SIG_CHECK_ACCOUNTS"=>125,
   "STEEM_MAX_TIME_UNTIL_EXPIRATION"=>3600,
   "STEEM_MAX_TRANSACTION_SIZE"=>65536,
   "STEEM_MAX_UNDO_HISTORY"=>10000,
   "STEEM_MAX_URL_LENGTH"=>127,
   "STEEM_MAX_VOTE_CHANGES"=>5,
   "STEEM_MAX_VOTED_WITNESSES_HF0"=>19,
   "STEEM_MAX_VOTED_WITNESSES_HF17"=>20,
   "STEEM_MAX_WITHDRAW_ROUTES"=>10,
   "STEEM_MAX_WITNESS_URL_LENGTH"=>2048,
   "STEEM_MIN_ACCOUNT_CREATION_FEE"=>1,
   "STEEM_MIN_ACCOUNT_NAME_LENGTH"=>3,
   "STEEM_MIN_BLOCK_SIZE_LIMIT"=>65536,
   "STEEM_MIN_BLOCK_SIZE"=>115,
   "STEEM_MIN_CONTENT_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_MIN_CURATE_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_MIN_PERMLINK_LENGTH"=>0,
   "STEEM_MIN_REPLY_INTERVAL"=>20000000,
   "STEEM_MIN_REPLY_INTERVAL_HF20"=>3000000,
   "STEEM_MIN_ROOT_COMMENT_INTERVAL"=>300000000,
   "STEEM_MIN_COMMENT_EDIT_INTERVAL"=>3000000,
   "STEEM_MIN_VOTE_INTERVAL_SEC"=>3,
   "STEEM_MINER_ACCOUNT"=>"miners",
   "STEEM_MINER_PAY_PERCENT"=>100,
   "STEEM_MIN_FEEDS"=>7,
   "STEEM_MINING_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_MINING_TIME"=>"2016-03-24T17:00:00",
   "STEEM_MIN_LIQUIDITY_REWARD"=>
    {"amount"=>"1200000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_MIN_LIQUIDITY_REWARD_PERIOD_SEC"=>60000000,
   "STEEM_MIN_PAYOUT_SBD"=>
    {"amount"=>"20", "precision"=>3, "nai"=>"@@000000013"},
   "STEEM_MIN_POW_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_MIN_PRODUCER_REWARD"=>
    {"amount"=>"1000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_MIN_TRANSACTION_EXPIRATION_LIMIT"=>15,
   "STEEM_MIN_TRANSACTION_SIZE_LIMIT"=>1024,
   "STEEM_MIN_UNDO_HISTORY"=>10,
   "STEEM_NULL_ACCOUNT"=>"null",
   "STEEM_NUM_INIT_MINERS"=>1,
   "STEEM_OWNER_AUTH_HISTORY_TRACKING_START_BLOCK_NUM"=>3186477,
   "STEEM_OWNER_AUTH_RECOVERY_PERIOD"=>"2592000000000",
   "STEEM_OWNER_CHALLENGE_COOLDOWN"=>"86400000000",
   "STEEM_OWNER_CHALLENGE_FEE"=>
    {"amount"=>"30000", "precision"=>3, "nai"=>"@@000000021"},
   "STEEM_OWNER_UPDATE_LIMIT"=>3600000000,
   "STEEM_POST_AVERAGE_WINDOW"=>86400,
   "STEEM_POST_REWARD_FUND_NAME"=>"post",
   "STEEM_POST_WEIGHT_CONSTANT"=>1600000000,
   "STEEM_POW_APR_PERCENT"=>750,
   "STEEM_PRODUCER_APR_PERCENT"=>750,
   "STEEM_PROXY_TO_SELF_ACCOUNT"=>"",
   "STEEM_SBD_INTEREST_COMPOUND_INTERVAL_SEC"=>2592000,
   "STEEM_SECONDS_PER_YEAR"=>31536000,
   "STEEM_PROPOSAL_FUND_PERCENT_HF0"=>0,
   "STEEM_PROPOSAL_FUND_PERCENT_HF21"=>1000,
   "STEEM_RECENT_RSHARES_DECAY_TIME_HF19"=>"1296000000000",
   "STEEM_RECENT_RSHARES_DECAY_TIME_HF17"=>"2592000000000",
   "STEEM_REVERSE_AUCTION_WINDOW_SECONDS_HF6"=>1800,
   "STEEM_REVERSE_AUCTION_WINDOW_SECONDS_HF20"=>900,
   "STEEM_REVERSE_AUCTION_WINDOW_SECONDS_HF21"=>300,
   "STEEM_ROOT_POST_PARENT"=>"",
   "STEEM_SAVINGS_WITHDRAW_REQUEST_LIMIT"=>100,
   "STEEM_SAVINGS_WITHDRAW_TIME"=>"259200000000",
   "STEEM_SBD_START_PERCENT_HF14"=>200,
   "STEEM_SBD_START_PERCENT_HF20"=>900,
   "STEEM_SBD_STOP_PERCENT_HF14"=>500,
   "STEEM_SBD_STOP_PERCENT_HF20"=>1000,
   "STEEM_SECOND_CASHOUT_WINDOW"=>2592000,
   "STEEM_SOFT_MAX_COMMENT_DEPTH"=>255,
   "STEEM_START_MINER_VOTING_BLOCK"=>864000,
   "STEEM_START_VESTING_BLOCK"=>201600,
   "STEEM_TEMP_ACCOUNT"=>"temp",
   "STEEM_UPVOTE_LOCKOUT_HF7"=>60000000,
   "STEEM_UPVOTE_LOCKOUT_HF17"=>"43200000000",
   "STEEM_UPVOTE_LOCKOUT_SECONDS"=>43200,
   "STEEM_VESTING_FUND_PERCENT_HF16"=>1500,
   "STEEM_VESTING_WITHDRAW_INTERVALS"=>13,
   "STEEM_VESTING_WITHDRAW_INTERVALS_PRE_HF_16"=>104,
   "STEEM_VESTING_WITHDRAW_INTERVAL_SECONDS"=>604800,
   "STEEM_VOTE_DUST_THRESHOLD"=>50000000,
   "STEEM_VOTING_MANA_REGENERATION_SECONDS"=>432000,
   "STEEM_SYMBOL"=>{"nai"=>"@@000000021", "decimals"=>3},
   "VESTS_SYMBOL"=>{"nai"=>"@@000000037", "decimals"=>6},
   "STEEM_VIRTUAL_SCHEDULE_LAP_LENGTH"=>"18446744073709551615",
   "STEEM_VIRTUAL_SCHEDULE_LAP_LENGTH2"=>
    "340282366920938463463374607431768211455",
   "STEEM_MAX_LIMIT_ORDER_EXPIRATION"=>2419200,
   "STEEM_DELEGATION_RETURN_PERIOD_HF0"=>604800,
   "STEEM_DELEGATION_RETURN_PERIOD_HF20"=>432000,
   "STEEM_RD_MIN_DECAY_BITS"=>6,
   "STEEM_RD_MAX_DECAY_BITS"=>32,
   "STEEM_RD_DECAY_DENOM_SHIFT"=>36,
   "STEEM_RD_MAX_POOL_BITS"=>64,
   "STEEM_RD_MAX_BUDGET_1"=>"17179869183",
   "STEEM_RD_MAX_BUDGET_2"=>268435455,
   ve"STEEM_RD_MAX_BUDGET_3"=>2147483647,
   "STEEM_RD_MAX_BUDGET"=>268435455,
   "STEEM_RD_MIN_DECAY"=>64,
   "STEEM_RD_MIN_BUDGET"=>1,
   "STEEM_RD_MAX_DECAY"=>4294967295,
   "STEEM_ACCOUNT_SUBSIDY_PRECISION"=>10000,
   "STEEM_WITNESS_SUBSIDY_BUDGET_PERCENT"=>12500,
   "STEEM_WITNESS_SUBSIDY_DECAY_PERCENT"=>210000,
   "STEEM_DEFAULT_ACCOUNT_SUBSIDY_DECAY"=>347321,
   "STEEM_DEFAULT_ACCOUNT_SUBSIDY_BUDGET"=>797,
   "STEEM_DECAY_BACKSTOP_PERCENT"=>9000,
   "STEEM_BLOCK_GENERATION_POSTPONED_TX_LIMIT"=>5,
   "STEEM_PENDING_TRANSACTION_EXECUTION_LIMIT"=>200000,
   "STEEM_TREASURY_ACCOUNT"=>"steem.dao",
   "STEEM_TREASURY_FEE"=>10000,
   "STEEM_PROPOSAL_MAINTENANCE_PERIOD"=>3600,
   "STEEM_PROPOSAL_MAINTENANCE_CLEANUP"=>86400,
   "STEEM_PROPOSAL_SUBJECT_MAX_LENGTH"=>80,
   "STEEM_PROPOSAL_MAX_IDS_NUMBER"=>5},
 "id"=>1}
```

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://peakd.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 18](https://peakd.com/@krischik/using-steem-api-with-ruby-part-18)

## Next tutorial

* [Using Steem-API with Ruby Part 20](https://peakd.com/@krischik/using-steem-api-with-ruby-part-20)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #22](https://github.com/krischik/SteemRubyTutorial/issues/22)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo: [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Hive logo: [Hive Band Assets](https://hive.io/brand), CC BY-SA 4.0.
* Steem Engine logo: [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

-----

<center>![posts5060.png](https://files.steempeak.com/file/steempeak/krischik/JaSBtA1B-posts-50-60.png)![comments5870.png](https://files.steempeak.com/file/steempeak/krischik/3zh0hy1H-comments-58-70.png)![votes6680.png](https://files.steempeak.com/file/steempeak/krischik/VVR0lQ3T-votes-66-80.png)![level9090.png](https://files.steempeak.com/file/steempeak/krischik/K8PLgaRh-level-90-90.png)![payout6680.png](https://files.steempeak.com/file/steempeak/krischik/EKjrC9xN-payout-66-80.png)![commented5870.png](https://files.steempeak.com/file/steempeak/krischik/bMY0fJGX-commented-58-70.png)![voted5060.png](https://files.steempeak.com/file/steempeak/krischik/P5yFKQ8S-voted-50-60.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
