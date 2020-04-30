# Using Steem-API with Ruby Part XXXXX — XXXXX

utopian-io tutorials ruby steem-api programming palnet neoxian marlians stem
utopian.pay

<center>![Steemit_Ruby.png](https://steemitimages.com/500x270/https://ipfs.busy.org/ipfs/QmSDiHZ9ng7BfYFMkvwYtNVPrw3nvbzKBA1gEj3y9vU6qN)</center>
<center>![Steemit_Ruby_Engine.png](https://cdn.steemitimages.com/DQmR1jWexK1B1gGwUgcVdGtwRkAZPZ5rUwBXBt6x55TMPjY/Steemit_Ruby_Engine.png)</center>

## Repositories

### SteemRubyTutorial

All examples from this tutorial can be found as fully functional scripts on GitHub:

* [SteemRubyTutorial](https://github.com/krischik/SteemRubyTutorial)
* steem-api sample code: [Steem-Dump-XXXXX.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-XXXXX.rb)
* radiator sample code: [Steem-Print-XXXXX.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-XXXXX.rb).

### steem-ruby

* Project Name: Steem Ruby (with Hive patches)
* Repository: [https://github.com/krischik/steem-ruby](https://github.com/krischik/steem-ruby)
* Official Documentation: [https://www.rubydoc.info/gems/steem-ruby](https://www.rubydoc.info/gems/steem-ruby)
* Official Tutorial: N/A

### steem-mechanize

* Project Name: Steem Mechanize (with Hive patches)
* Repository: [https://github.com/krischik/steem-mechanize](https://github.com/krischik/steem-mechanize)
* Official Documentation: [https://www.rubydoc.info/gems/steem-mechanize](https://www.rubydoc.info/gems/steem-mechanize)
* Official Tutorial: N/A

### radiator

* Project Name: Radiator (with Hive patches)
* Repository: [https://github.com/krischik/radiator](https://github.com/krischik/radiator)
* Official Documentation: [https://www.rubydoc.info/gems/radiator](https://www.rubydoc.info/gems/radiator)
* Official Tutorial: [https://developers.steem.io/tutorials-ruby/getting_started](https://developers.steem.io/tutorials-ruby/getting_started)

### Steem Engine

<center>![steem-engine_logo-horizontal-dark.png](https://cdn.steemitimages.com/DQmcuU8q2NnZjUcj74ChEQDsUBdE4LNc8t9LpucE25TP7Sf/steem-engine_logo-horizontal-dark.png)</center>

* Project Name: Steem Engine
* Home Page: [https://steem-engine.com](https://steem-engine.com)
* Repository: [https://github.com/harpagon210/steem-engine](https://github.com/harpagon210/steem-engine)
* Official Documentation: [https://github.com/harpagon210/sscjs](https://github.com/harpagon210/sscjs) (JavaScript only)
* Official Tutorial: N/A

## What Will I Learn?

This tutorial shows how to interact with the Steem and Hive blockchain as well as the Steem and Hive database using Ruby. When using Ruby you have three APIs available to chose: **steem-api**, **steem-mechanize** and **radiator** which differentiates in how return values and errors are handled:

* **steem-api** uses closures and exceptions and provides low level computer readable data.
* **steem-mechanize** drop in replacement for steem-api with more performant network I/O
* **radiator** uses classic function return values and provides high level human readable data.

Since all APIs have advantages and disadvantages sample code for both APIs will be provided so the reader ca decide which is more suitable.

## Requirements

Basic knowledge of Ruby programming is needed. It is necessary to install at least Ruby 2.5 as well as the following standart ruby gems:

```sh
gem install bundler
gem install colorize
gem install contracts
```

For Hive compatibility you need the hive patched versions of the `steem-ruby` and `radiator` ruby gems. These are not yet available in the standard ruby gem repository and you need to install them from source. For this you change into the directory you keep Git clones and use the following commands:

```sh
git clone "https://github.com/krischik/steem-ruby"

pushd "steem-ruby"
    gem build "steem-ruby.gemspec"
    gem install "steem-ruby"
popd

git clone "https://github.com/krischik/steem-mechanize"

pushd "steem-mechanize"
    gem build "steem-mechanize.gemspec"
    gem install "steem-mechanize"
popd

git clone "https://github.com/krischik/radiator"

pushd "radiator"
    gem build "radiator.gemspec"
    gem install "radiator"
popd
```

**Note:** All APIs steem-ruby, steem-mechanize and radiator provide a file called `steem.rb`. This means that:

1. When more then one APIs is installed ruby must be told which one to use.
2. The three APIs can't be used in the same script.

If there is anything not clear you can ask in the comments.

## Difficulty

For reader with programming experience this tutorial is **basic level**.

## Tutorial Contents

## Implementation using steem-ruby

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting: [Steem-Dump-XXXXX.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Dump-XXXXX.rb).

The output of the command (for the steem account) looks like this:

<center>![Screenshot at Feb 13 145331.png](https://files.steempeak.com/file/steempeak/krischik/bj5gfctG-Screenshot20at20Feb20132014-53-31.png)</center>

## Implementation using radiator

-----

```ruby
```

-----

**Hint:** Follow this link to Github for the complete script with comments and syntax highlighting : [Steem-Print-XXXXX.rb](https://github.com/krischik/SteemRubyTutorial/blob/master/Scripts/Steem-Print-XXXXX.rb).

The output of the command (for the steem account) looks identical to the previous output:

<center>![Screenshot at XXXXX.png](https://files.steempeak.com/file/steempeak/krischik/3dURm96L-ScreenshotXXXXX.png)</center>

# Curriculum

## First tutorial

* [Using Steem-API with Ruby Part 1](https://peakd.com/@krischik/using-steem-api-with-ruby-part-1)

## Previous tutorial

* [Using Steem-API with Ruby Part XXXXX](https://peakd.com/@krischik/using-steem-api-with-ruby-part-XXXXX)

## Next tutorial

* [Using Steem-API with Ruby Part XXXXX](https://peakd.com/@krischik/using-steem-api-with-ruby-part-XXXXX)

## Proof of Work

* GitHub: [SteemRubyTutorial Issue #XXXXX](https://github.com/krischik/SteemRubyTutorial/issues/XXXXX)

## Image Source

* Ruby symbol: [Wikimedia](https://commons.wikimedia.org/wiki/File:Ruby_logo.svg), CC BY-SA 2.5.
* Steemit logo: [Wikimedia](https://commons.wikimedia.org/wiki/File:Steemit_New_Logo.png), CC BY-SA 4.0.
* Hive logo: [Hive Band Assets](https://hive.io/brand), CC BY-SA 4.0.
* Steem Engine logo: [Steem Engine](https://steem-engine.com)
* Screenshots: @krischik, CC BY-NC-SA 4.0

## Beneficiary

<center>![Beneficiary.png](https://cdn.steemitimages.com/DQmYnQfCi8Z12jkaNqADKc37gZ89RKdvdLzp7uXRjbo1AHy/image.png)</center>

-----

<center>![posts5060.png](https://files.steempeak.com/file/steempeak/krischik/JaSBtA1B-posts-50-60.png)![comments5870.png](https://files.steempeak.com/file/steempeak/krischik/3zh0hy1H-comments-58-70.png)![votes6680.png](https://files.steempeak.com/file/steempeak/krischik/VVR0lQ3T-votes-66-80.png)![level9090.png](https://files.steempeak.com/file/steempeak/krischik/K8PLgaRh-level-90-90.png)![payout6680.png](https://files.steempeak.com/file/steempeak/krischik/EKjrC9xN-payout-66-80.png)![commented5870.png](https://files.steempeak.com/file/steempeak/krischik/bMY0fJGX-commented-58-70.png)![voted5060.png](https://files.steempeak.com/file/steempeak/krischik/P5yFKQ8S-voted-50-60.png)</center>

<center>![posts5060.png](https://images.hive.blog/50x60/http://hivebuzz.me/accounts/@krischik/posts.png)![comments5870.png](https://images.hive.blog/58x70/http://hivebuzz.me/accounts/@krischik/comments.png)![upvotes6680.png](https://images.hive.blog/66x80/http://hivebuzz.me/accounts/@krischik/upvotes.png)![level9090.png](https://images.hive.blog/90x90/http://hivebuzz.me/accounts/@krischik/level.png)![payout6680.png](https://images.hive.blog/66x80/http://hivebuzz.me/accounts/@krischik/payout.png)![replies5870.png](https://images.hive.blog/58x70/http://hivebuzz.me/accounts/@krischik/replies.png)![upvoted5060.png](https://images.hive.blog/50x60/http://hivebuzz.me/accounts/@krischik/upvoted.png)</center>

<!-- vim: set wrap tabstop=8 shiftwidth=3 softtabstop=3 expandtab : -->
<!-- vim: set textwidth=0 filetype=markdown foldmethod=marker nospell : -->
<!-- vim: set spell spelllang=en_gb fileencoding=utf-8 : -->
