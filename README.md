# Brakecheck

Test breakage when important gems are stale, to always have the latest versions of rubocop/brakeman/bundler-audit etc.

## Installation


```ruby
# Gemfile
gem 'brakecheck', group: :test, require: false
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install brakecheck
```

## Usage

### CLI

```
brakecheck rubocop
```

### RSpec

```ruby
require 'brakecheck/rspec'

describe "Brakeman" do
  before do
    WebMock.allow_net_connect!
  end

  it "is up to date" do
    expect("brakeman").to be_the_latest_version
  end

  after do
    WebMock.disable_net_connect!
  end
end
```

__NB: This gem uses rubygems.com API to determine the latest version.__

## TODO

Webmock auto allow rubygems queries.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/apanzerj/brakecheck.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


> “A simple gem that makes it easy to have” == bla bla
- @grosser
