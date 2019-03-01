# Using Steem-API with Ruby Part 7 — Print Posting Votes

utopian-io tutorials ruby steem-api programming

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-Balances.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Posting-Votes.rb)
* radiator sample code: [Steem-Print-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Posting-Votes.rb).

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

This chapter teaches how to display all up and downvotes in present on any posting. In the next part will teach how to calculate the value in SBD for each post.

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

Information on the postings are accessed via the `get_active_votes` method of the `CondenserApi`. The method takes two parameter: the authors name and the id of the posting. Both can be extracted from the URL of the posting. As Result you get an array of voting results:

<center>![Screenshot at Feb 26 16-17-18.png](https://cdn.steemitimages.com/DQmcxuPUSRvRXFj2D4mq5UTDpacnodJzqRFmh1Lk5mXedup/Screenshot%20at%20Feb%2026%2016-17-18.png)</center>

| Name      | Desciption                                         |
|-----------|----------------------------------------------------|
|voter      |Name of the voter.                                  |
|percent    |percentage of vote (times 10000).                   |
|weight     |Used to calculate the vote value.                   |
|rshares    |Used to calculate the vote value.                   |
|reputation |Voters reputation. Not used any more and always 0.  |
|time       |Time and date of the actual vote.                   |

**A little reminder:** A % sign behind the number usually means that the number was multiplied by 100. So 1% equals 0.01 and 100% equals 1.0. Steem itself however doesn't use floating-point numbers and multiplies the percentage with 10000 instead to make them integers while still allowing for a 0.0001 / 0.01% precision.

The correct use if `weight` and `rshares` is rather complex and will be described in a separate tutorial.

## Implementation using steem-ruby

To ease the use of the voting values we define a `Value` class which does all the a parsing and converts the integer values into floating points as well as converting time stamps ti the `Time` instances. Note that floating point values are not as precise but easier to use the fixed points numbers.

-----

Class to handle vote values from postings.

```ruby
class Vote < Steem::Type::BaseType
   include Contracts::Core
   include Contracts::Builtin

   attr_reader :voter, :percent, :weight, :rshares, :reputation, :time
```

Create a new instance from the data returned from the `get_active_votes` method. The percent is divided by 10000 to make the value mathematically correct.

```ruby
   Contract HashOf[String => Or[String, Num]] => nil
   def initialize(value)
      super(:vote, value)

      @voter      = value.voter
      @percent    = value.percent / 10000.0
      @weight     = value.weight
      @rshares    = value.rshares
      @reputation = value.reputation
      @time       = Time.strptime(value.time + "Z" , "%Y-%m-%dT%H:%M:%S")

      return
   end
```

Create a colorised string from the instance. The vote percentages are multiplied with 100 and are colorised (positive values are printed in green, negative values in red and zero votes (yes they exist) are shown in grey), for improved human readability.

```ruby
   Contract None => String
   def to_ansi_s
      _percent = @percent * 100.0

      return (
      "%1$-16s : " + "%2$7.2f%%".colorize(
         if _percent > 0 then
            :green
         elsif _percent < 0 then
            :red
         else
            :white
         end
      ) + "%3$12d" + "%4$15d" + "%5$20s") % [
         @voter,
         _percent,
         @weight,
         @rshares,
         @time.strftime("%Y-%m-%d %H:%M:%S")]
   end
```

Print a list a vote values:

1. Loop over all votes.
2. convert the vote JSON object into the ruby `Vote` class.
3. print as ansi strings.

```ruby
   Contract ArrayOf[HashOf[String => Or[String, Num]] ] => nil
   def self.print_list (votes)
      votes.each do |vote|
         _vote = Vote.new vote

         puts _vote.to_ansi_s
      end

      return
   end
```

Print the votes from a postings given as URLs:

1. Extract the posting ID and author name from the URL with standard string operations. 
2. Print a short header
3. Request the list of votes from `Condenser_Api` using `get_active_votes`
4. print the votes.

```ruby
   Contract String => nil
   def self.print_url (url)
      _slug              = url.split('@').last
      _author, _permlink = _slug.split('/')

      puts ("Post Author      : " + "%1$s".blue) % _author
      puts ("Post ID          : " + "%1$s".blue) % _permlink
      puts ("Voter name       :  percent      weight        rshares    vote date & time")

      Condenser_Api.get_active_votes(_author, _permlink) do |votes|
         if votes.length == 0 then
            puts "No votes found.".yellow
         else
            Vote.print_list votes
         end
      rescue => error
         Kernel::abort(("Error reading posting “%1$s”:\n".red + "%2$s") % [_permlink, error.to_s])
      end

      return
   end
end
```

-----

To avoid replications the rest of the operation is described in the radiator chapter.

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-Posting-Votes.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 26 16-36-28.png](https://cdn.steemitimages.com/DQmQzNSb7JzhnDC3X8DCnxfWYKfFWss8LZeBJXsBWXQVdwg/Screenshot%20at%20Feb%2026%2016-36-28.png)</center>

## Implementation using radiator

To avoid replications the `Vote` class is only described in the steem-ruby chapter

-----

```ruby
begin
```

create instance to the steem condenser API which will give us access to the active votes.

```ruby
   Condenser_Api = Radiator::CondenserApi.new
rescue => error
```

I am using `Kernel::abort` so the script ends when data can't be loaded

```ruby
   Kernel::abort("Error reading global properties:\n".red + error.to_s)
end
```

Display help if no URL are given.

```ruby
if ARGV.length == 0 then
   puts "
Steem-Print-Posting-Votes — Print voting on account.

Usage:
   Steem-Print-Posting-Votes URL …
"
else
```

Loop over all URLs given and print the values using the Vote class.

```ruby
   ARGV.each do |_url|
      Vote.print_url _url
   end
end
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-Posting-Votes.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-Posting-Votes.rb).

The output of the command (for the steem account) looks similar to the previous output:

<center>![Screenshot at Feb 26 16-46-37.png](https://cdn.steemitimages.com/DQmUNJQyFoRnJEWQCbqxUFBv3adzoNodY3abujVbh7BrTp9/Screenshot%20at%20Feb%2026%2016-46-37.png)</center>

This time a posting with a negative vote in red is shown.

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://steemit.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 6](https://steemit.com/@krischik/using-steem-api-with-ruby-part-6)

## Next tutorial

* [Using Steem-API with Ruby Part 8](https://steemit.com/@krischik/using-steem-api-with-ruby-part-8)

## Proof of Work

* GitHub Task: [SteemRubyTutorial Issue #9](https://github.com/krischik/SteemRubyTutorial/issues/9)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![](https://cdn.steemitimages.com/DQmVbTpJiKYkUN7XWyRcR6pEKjKG8jyZ24Mp9gjFTcSBzpH/image.png)</center>

-----

<center>![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
