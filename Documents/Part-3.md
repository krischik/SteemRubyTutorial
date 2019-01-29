# Using Steem-API with Ruby Part 3
utopian-io tutorials ruby steem-api programming

![Steemit_Ruby.jpg](https://steemitimages.com/500x270/http://ipfs.busy.org/ipfs/Qmb2hiQCAWohe59NoRHxZXE4X5ok29ZRmNETGHE8qZdwQR)

## Repository
### steem-ruby

* Project Name: Steem Ruby
* Repository: [https://github.com/steemit/steem-ruby](https://github.com/steemit/steem-ruby)

### radiator

* Project Name: Radiator
* Repository: [https://github.com/inertia186/radiator](https://github.com/inertia186/radiator)

## What Will I Learn?

This tutorial shows how to interact with the Steem blockchain and Steem database using Ruby. When using Ruby you have two APIs available to chose: **steem-api** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **radiator** uses classic function return values and provides high level human readable data.

Since both APIs have advantages and disadvantages I have provided sample code for both APIs so you can decide which is more suitable for you.

In this 2nd part you learn the use of the classes `Steem::Type::Amount` and `Radiator::Type::Amount` and how to handle account balaces using them.

## Requirements

You should have basic knowledge of Ruby programming and have an up to date ruby installed on your computer. If there is anything not clear you can ask in the comments.

In order to use the provided sample you need to install at least Ruby 2.5 and the following ruby gems:

```sh
gem install bundler
gem install colorize
gem install steem-ruby
gem install radiator
```

**Note:** Both steem-ruby and radiator provide a file called `steem.rb`. This means that:

1. When you install both APIs you need to tell ruby which one to use.
2. You can't use both APIs in the same script.

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

In this second part of the tutorial I demonstrate how to print out account balances from a list of accounts passed on command line. The data will be formatted and a simple calculation is performed to show how you can use arithmetic on account balances.

As mentioned there will be two examples showing the differences. Both `…::Amount` classes have there weaknesses which I compensate by introducing an extended `Amount` class making the rest of the code identical.

## Implementation using steem-ruby

Check out the comments in the sample code for more details. 

Hint: opening  [Steem-Dump-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/feature/Part2/Scripts/Steem-Dump-Balances.rb) will give you a nice display with syntax highlight.

```ruby
```

The output of the command (for the steem account) looks like this:

## Steem-Print-Accounts.rb using radiator

[Steem-Print-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/feature/Part2/Scripts/Steem-Print-Balances.rb)

Check out the comments in the sample code for more details.

Hint: opening  [Steem-Print-Balances.rb on GitHub](https://github.com/krischik/SteemRubyTutorial/blob/feature/Part2/Scripts/Steem-Print-Balances.rb) will give you a nice display with syntax highlight.

```ruby
```

The output of the command (for the steem account) looks like this:

# Curriculum
## First tutorial

* [Using Steem-API with Ruby Part 1](https://busy.org/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part 2](https://busy.org/@krischik/using-steem-api-with-ruby-part-1)

## Next tutorial

* [Using Steem-API with Ruby Part 4](https://busy.org/@krischik/using-steem-api-with-ruby-part-4)

## Proof of Work

* [SteemRubyTutorial on GitHub](https://github.com/krischik/SteemRubyTutorial)

![image.png](https://ipfs.busy.org/ipfs/Qmb3WV6M4fDUxnnrLjkNXqAV7rd6rh2haRdriYQsbZT1Pr)

<center> ![comment](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/Comments.png) ![votes](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Votes.png) ![posts](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Posts.png) ![level](http://steemitimages.com/100x80/http://steemitboard.com/@krischik/Level.png) ![payout](http://steemitimages.com/70x80/http://steemitboard.com/@krischik/Payout.png) ![commented](http://steemitimages.com/60x70/http://steemitboard.com/@krischik/Commented.png) ![voted](https://steemitimages.com/50x60/http://steemitboard.com/@krischik/voted.png) </center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
