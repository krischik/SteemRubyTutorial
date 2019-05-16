# Using Steem-API with Ruby Part 6 — Print Account Balances improved

utopian-io tutorials ruby steem-api programming

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Vesting.rb)
* radiator sample code: [Steem-Print-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Vesting.rb).

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

Since both APIs have advantages and disadvantages sample code for both APIs will be provided so the reader ca decide which is more suitable.

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

There are three ways to get the list of delegations.

**Note:** The method `Vesting.print_list` is part of the sample code further down. It pretty prints a list of vestings.

### `find_vesting_delegations`

`find_vesting_delegations` is the simplest method. It will return the first 1000 delegations from one account. Suitable for accounts with less then 1000 delegations.

```ruby
_vesting = Database_Api.find_vesting_delegations(account: account)

Vesting.print_list _vesting.result.delegations
```

### `get_vesting_delegations`

`get_vesting_delegations` returns a subset of an accounts delegation. This is helpful for accounts with more then a thousand delegations like steem. The 2nd parameter is the first delegatee to return. The 3nd parameter is maximum amount results to return. Must be less then 1000.

The loop needed is pretty complicated as the last element on each iteration is duplicated as first element of the next iteration.

```ruby
# empty string denotes start of list

_previous_delegatee = ""

loop do
   # get the next 1000 items.

   _vesting = Condenser_Api.get_vesting_delegations(account, _previous_delegatee, 1000)

   # no elements found, end loop now. This only
   # happens when the account doesn't exist.

break if _vesting.result.length == 0

   # get and remove the last element. The last element
   # meeds to be removed as it will be dupplicated
   # as firt element in the next itteration.

   _last_vest = Vesting.new _vesting.result.pop

   # check of the delegatee of the current last element
   # is the same as the last element of the previous
   # itteration. If this happens we have reached the
   # end of the list

   if _previous_delegatee == _last_vest.delegatee then
      # In the last itteration there will also
      # be only one element which we need to print.

      puts _last_vest.to_ansi_s
      break
   else
      # Print the list. 

      Vesting.print_list _vesting.result

      # remember the delegatee for the next interation.

      _previous_delegatee = _last_vest.delegatee 
   end
end
```

### `list_vesting_delegations`

`get_vesting_delegations` returns the delegations of multiple accounts at once. Useful if you want to iterate over all existing delegations. The start parameter takes the delegator / delegatee pair to start, limit is the amount of results (less then 1000) and order is always "by_delegation".

```ruby
# two empty strings denotes start of list

_previous_end = ["" , ""]

loop do
   # get the next 1000 items.

   _vesting = Database_Api.list_vesting_delegations(start: _previous_end, limit: 1000, order: "by_delegation")

   # no elements found, end loop now. This only
   # happens when the delegator / delegatee pair 
   # used as start marker doesn't exist.

   break if _vesting.result.length == 0

   # get the delegator / delegatee pair 
   # of the last element

   _last_vest = Vesting.new _vesting.result.delegations.last         
   _current_end = [_last_vest.delegator, _last_vest.delegatee]

   # check of the delegator / delegatee pair of the
   # current last element is the same as the last
   # element of the previous itteration. If this
   # happens we have reached the end of the list

   break if _previous_end == _current_end

   # Print the list

   Vesting.print_list _vesting.result.delegations

   # remember the delegator / delegatee pair for
   # the next interation.

   _previous_end = _current_end
end
```

## Implementation using steem-ruby

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Balances.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 13 145331.png](https://files.steempeak.com/file/steempeak/krischik/bj5gfctG-Screenshot20at20Feb20132014-53-31.png)</center>

## Implementation using radiator

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Balances.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at Feb 13 145420.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-Screenshot20at20Feb20132014-54-20.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 9](https://steemit.com/@krischik/using-steem-api-with-ruby-part-9)

## Next tutorial

* [Using Steem-API with Ruby Part 11](https://steemit.com/@krischik/using-steem-api-with-ruby-part-11)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #8](https://github.com/krischik/SteemRubyTutorial/issues/7)

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
