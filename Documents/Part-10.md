# Using Steem-API with Ruby Part 10 — Print Account Delegation of Vesting

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Vesting.rb)
* radiator sample code: [Steem-Print-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Vesting.rb).

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

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby to access an accounts incoming and outgoing vestings.

When using Ruby you have two APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

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

For reader with programming experience this tutorial is **medium level**.

## Tutorial Contents

There are three ways to get the list of delegations using either the database API or the condenser API.

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
   # meeds to be removed as it will be duplicated
   # as first element in the next iteration.

   _last_vest = Vesting.new _vesting.result.pop

   # check of the delegatee of the current last element
   # is the same as the last element of the previous
   # iteration. If this happens we have reached the
   # end of the list

   if _previous_delegatee == _last_vest.delegatee then
      # In the last itteration there will also
      # be only one element which we need to print.

      puts _last_vest.to_ansi_s
      break
   else
      # Print the list.

      Vesting.print_list _vesting.result

      # remember the delegatee for the next integration.

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

   break if _vesting == nil || _vesting.result.length == 0

   # get the delegator / delegatee pair
   # of the last element

   _last_vest = Vesting.new _vesting.result.delegations.last
   _current_end = [_last_vest.delegator, _last_vest.delegatee]

   # check of the delegator / delegatee pair of the
   # current last element is the same as the last
   # element of the previous iteration. If this
   # happens we have reached the end of the list

    if _previous_end == _current_end then
      # In the last iteration there will also
      # be only one element which we need to print.

      puts _last_vest.to_ansi_s

      break
    else
      # Print the list.

      Vesting.print_list(_vesting.result.delegations, accounts)

      # remember the delegator / delegatee pair for
      # the next iteration.

      _previous_end = _current_end
   end
end
```

**Note:** As of writing `radiator` doesn't supply an implementation for `get_vesting_delegations`.

## Implementation using radiator

With the radiator implementation the access of delegation from a given list of accounts is demonstrated.

-----

A class to hold a vesting delegation values. The vesting
holds the following values

* **id**		   [Number]  ID unique to all delegations.
* **delegator**		   [String]  Account name of the account who delegates
* **delegatee**		   [String]  Account name of the account who is delegates to
* **vesting_shares**	   [Amount]  the actual amount in VESTS
* **min_delegation_time**  [Time]    Start of delegation

```ruby
class Vesting < Radiator::Type::Serializer
   include Contracts::Core
   include Contracts::Builtin

   attr_reader :id, :delegator, :delegatee, :vesting_shares, :min_delegation_time
```ruby

Create a new instance from the data returned by from `find_vesting_delegations`, `get_vesting_delegations` or `list_vesting_delegations`.

```ruby
   Contract HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]] ]] => nil
   def initialize(value)
      super(:id, value)

      @id                  = value.id
      @delegator           = value.delegator
      @delegatee           = value.delegatee
      @vesting_shares      = Amount.new (value.vesting_shares)
      @min_delegation_time = Time.strptime(value.min_delegation_time + ":Z" , "%Y-%m-%dT%H:%M:%S:%Z")

      return
   end
```

Create a colourised string from the instance. The vote percentages are multiplied with 100 and are colorised (positive values are printed in green, negative values in red and zero votes (yes they exist) are shown in grey), for improved human readability.

```ruby
   Contract None => String
   def to_ansi_s
      # All the magic happens in the `%` operators which
      # calls sprintf which in turn formats the string.
      return (
         "%1$10d | " +
         "%2$-16s ⇒ " +
         "%3$-16s | " +
         "%4$-68s | " +
         "%5$20s | ") % [
            @id,
            @delegator,
            @delegatee,
            @vesting_shares.to_ansi_s,
            @min_delegation_time.strftime("%Y-%m-%d %H:%M:%S")
         ]
   end
```

Print a list a vesting values:

1. Loop over all vesting.
2. convert the vote JSON object into the ruby `Vesting` class.
3. print as ansi strings.

```ruby
   Contract ArrayOf[HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]] ]] ] => nil
   def self.print_list (vesting)
      vesting.each do |vest|
         _vest = Vesting.new vest

         puts _vest.to_ansi_s
      end

      return
   end
```

Print the vesting the given account makes:

```ruby
   Contract String => nil
   def self.print_account (account)

      puts ("-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+")

      # `get_vesting_delegations` returns a subset of an
      # accounts delegation. This is helpful for accounts
      # with more then a thousand delegations like steem.
      # The 2nd parameter is the first delegatee to
      # return. The 3rd parameter is maximum amount results
      # to return. Must be less then 1000.
      #
      # The loop needed is pretty complicated as the last
      # element on each iteration is duplicated as first
      # element of the next iteration.

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
         # as firt element in the next iteration.

         _last_vest = Vesting.new _vesting.result.pop

         # check of the delegatee of the current last element
         # is the same as the last element of the previous
         # iteration. If this happens we have reached the
         # end of the list

         if _previous_delegatee == _last_vest.delegatee then
            # In the last iteration there will also
            # be only one element which we need to print.

            puts _last_vest.to_ansi_s
            break
         else
            # Print the list.

            Vesting.print_list _vesting.result

            # remember the delegatee for the next iteration.

            _previous_delegatee = _last_vest.delegatee
         end
      end

      return
   end
end
```

Initialise access to Condenser and Steem database as well as set the conversion values used by the `Amount` class.

```ruby
begin
   # create instance to the steem condenser API which
   # will give us access to to the global properties and
   # median history

   Condenser_Api = Radiator::CondenserApi.new

   # read the global properties and median history values
   # and calculate the conversion Rate for steem to SBD
   # We use the Amount class from Part 2 to convert the
   # string values into amounts.

   _median_history_price = Condenser_Api.get_current_median_history_price.result
   _base                 = Amount.new _median_history_price.base
   _quote                = Amount.new _median_history_price.quote
   SBD_Median_Price      = _base.to_f / _quote.to_f

   _global_properties        = Condenser_Api.get_dynamic_global_properties.result
   _total_vesting_fund_steem = Amount.new _global_properties.total_vesting_fund_steem
   _total_vesting_shares     = Amount.new _global_properties.total_vesting_shares
   Conversion_Rate_Vests     = _total_vesting_fund_steem.to_f / _total_vesting_shares.to_f

   # create instance to the steem database API

   Database_Api = Radiator::DatabaseApi.new

rescue => error
   # I am using `Kernel::abort` so the script ends when
   # data can't be loaded

   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

Read a list of accounts from the command line and print
the vesting delegation for each account.

```ruby
if ARGV.length == 0 then
   puts "
Steem-Dump-Accounts — Dump account infos from Steem database

Usage:
   Steem-Dump-Accounts account_name …

"
else
   # read arguments from command line

   Account_Names = ARGV

   puts ("        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |")

   Account_Names.each do |account|
      Vesting.print_account account
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Vesting.rb).

The output of the command (for my and the steampeak account) looks like this:

<center>![Screenshot at May 23 14-26-21.png](https://cdn.steemitimages.com/DQmZt8Ui1ELYDyN57Mb1RQPDhQ7WGjyGjiv5afT1yMfmPcp/Screenshot%20at%20May%2023%2014-26-21.png)</center>

## Implementation using steem-ruby

With the steem-ruby implementation the access to delegation from and to a given list of account makes is demonstrated. This is a very time consuming process as we need to iterate over every delegation of the database. Run time can easily exceed an hour.

-----

Again a class is used to hold the date. Note that Only the differences to radiator implementation is shown.

```ruby
class Vesting < Steem::Type::BaseType
```

Since we need to use `list_vesting_delegations` method which return all vestings currently stored the data is
filtered inside the loop.

This helper method will check if delegation is related to the given list of accounts either as delegator or delegatee.

```ruby
   Contract ArrayOf[String] => Bool
   def is_accounts (accounts)
      return (accounts.include? @delegator) || (accounts.include? @delegatee)
   end
```

Prints all vesting values which are related to given list of accounts:

1. Loop over all vesting.
2. checks is vesting is related to the list of accounts
3. convert the vote JSON object into the ruby
`Vesting` class.
4. print as ansi strings.

```ruby
   Contract ArrayOf[HashOf[String => Or[String, Num, HashOf[String => Or[String, Num]] ]] ], ArrayOf[String] => nil
   def self.print_list (vesting, accounts)
      vesting.each do |vest|
         _vest = Vesting.new vest

         if _vest.is_accounts accounts then
            puts _vest.to_ansi_s
         end
      end

      return
   end
```

Fetches all the vestings form the database and prints those who are related to the given list of accounts. Fetching all delegation takes quite a long time and there is a good change that there will be a network error before the operation finishes.

For this a crude hack which skips over the **steem** account is applied. Even with skipping over the **steem** account the operation can take half an hour. To keep the user informed a  progress indicator is added aw well.

```ruby
   Contract ArrayOf[String] => nil
   def self.print_accounts (accounts)

      puts ("-----------|------------------+------------------+--------------------------------------------------------------------+----------------------+")

      # `get_vesting_delegations` returns the delegations
      # of multiple accounts at once. Useful if you want
      # to iterate over all existing delegations. It's also
      # the only way to find delegatees.
      #
      # The start parameter takes the delegator / delegatee
      # pair to start the search, limit is the maximum amount
      # of results to be returned (less then 1000) and order
      # is always "by_delegation".
      #
      # The loop needed is pretty complicated as the last
      # element on each iteration is duplicated as first
      # element of the next iteration.

      # empty strings denotes start of list

      _previous_end = ["", ""]

      loop do
         # get the next 1000 items.

         _vesting = Database_Api.list_vesting_delegations(start: _previous_end, limit: 10, order: "by_delegation")

         # no elements found, end loop now. This only
         # happens when the initial delegator / delegatee
         # pair doesn't exist.

      break if _vesting == nil || _vesting.result.length == 0

         # get the delegator / delegatee pair of the last
         #  element

         _last_vest = Vesting.new _vesting.result.delegations.pop
         _current_end = [_last_vest.delegator, _last_vest.delegatee]

         # Delete the progress indicator.

         print "\e[1K\r"

         # check of the delegatee of the current last element
         # is the same as the last element of the previous
         # iteration. If this happens we have reached the
         # end of the list

         if _previous_end == _current_end then
            # In the last iteration there will also
            # be only one element which we need to print.

            if _last_vest.is_accounts accounts then
               puts _last_vest.to_ansi_s
            end

            break
         else
            # Print the list.

            if _previous_end[0] != "steem" && _current_end[0] == "steem" then
               # The large majority of delegations are done
               # by the steem account. Not only will it
               # take more then an hour to iterate over the
               # steem delegations there is also a very
               # high likelihood of a network error
               # preventing the iteration from finishing.
               # For this we skip over the steem account.

               _previous_end = ["steem", "zzzzzzj"]
            else
               # remember the delegator / delegatee pair for
               # the next iteration.

               _previous_end = _current_end
            end
         end

         # Print the current position of the iteration as
         # progress indicator for the user.

         print (
            "%1$10d | " +
            "%2$-16s ⇒ " +
            "%3$-16s ") % [
               _last_vest.id,
               _last_vest.delegator,
               _last_vest.delegatee]
      end

      return
   end
end
```

Since all delegations from the database are read and this is quite a time consuming operation it would be wasteful to make one call for each account.

Instead the list of accounts is passed into the print method to filter all accounts at once.

The disadvantage being that the printed data isn't sorted by account.

```ruby
if ARGV.length == 0 then
   puts "
Steem-Dump-Accounts — Dump account infos from Steem database

Usage:
   Steem-Dump-Accounts account_name …

"
else
   # read arguments from command line

   Account_Names = ARGV

   puts ("        id | delegator        | delegatee        |                                                     vesting shares |  min delegation time |")

   Vesting.print_accounts Account_Names
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Vesting.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Vesting.rb).

The output of the command (for my and the steampeak account) looks like this:

<center>![Screenshot at May 24 14-03-04.png](https://cdn.steemitimages.com/DQmTjnxgXJZaNLYFnt2MAQ3AC6xogPdvKsywB1vLq2J5bFt/Screenshot%20at%20May%2024%2014-03-04.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 9](https://steemit.com/@krischik/using-steem-api-with-ruby-part-9)

## Next tutorial

* [Using Steem-API with Ruby Part 11](https://steemit.com/@krischik/using-steem-api-with-ruby-part-11)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #8](https://github.com/krischik/SteemRubyTutorial/issues/8)

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
