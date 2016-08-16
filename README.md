# Brakecheck

Test breakage when important gems are stale.

## Why?!? What's wrong with Bundler?

We use brakeman regularly and it's important to keep that up to date. This breaks the build if brakeman is not current. Bundler still requires that somebody run bundle update.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brakecheck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brakecheck

## Usage

1. Create a basic test
2. `include Brakecheck`
3. assert_latest or expect_latest

Rspec Matcher exampe:

 ```ruby
 expect('brakeman').to be_the_latest_version
 ```
 

__NB: This gem uses rubygems.com API to determine the latest version.__

## TODO

Webmock auto allow rubygems queries.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/brakecheck.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## @grosser Says
> “A simple gem that makes it easy to have” == bla bla
