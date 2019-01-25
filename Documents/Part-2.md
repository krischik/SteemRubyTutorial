# Using Steem-API with Ruby Part 1

![Steemit_Ruby.jpg](https://steemitimages.com/500x270/http://ipfs.busy.org/ipfs/Qmb2hiQCAWohe59NoRHxZXE4X5ok29ZRmNETGHE8qZdwQR)

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

In this 2nd part you learn the use of the classes `Steem::Type::Amount` and `Radiator::Type::Amount`.

## Requirements

You should have basic knowledge of Ruby programming and have an up to date ruby installed on your computer. If there is anything not clear you can ask in the comments.

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

## Difficulty

Provided you have some programming experience this tutorial is **basic level**.

## Tutorial Contents

In this second part of the tutorial I demonstrate how to print out account balances from a list of accounts passed on command line. The data will be formatted and a single calculations is performed to display.

As mentioned there will be two examples and both samples are complete with error handling. I do this because error handling is one of the areas where steem-api and radiator differ and also it's always good to learn how to handle error condition correctly.

## Implementation using steem-ruby

```ruby
```

The output of the command (for the steemit account) looks like this:

```
```

## Steem-Print-Accounts.rb using radiator

Check out the comments in the sample code for more details.

```ruby
```

The output of the command (for the steemit account) looks like this:

```
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
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 -->
