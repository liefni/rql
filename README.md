# RQL

RQL is a DSL for active record designed to allow derived/calculated attributes on models to be used in database queries.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rql'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rql

## Usage

You can define a derived attribute in your model like this:
```ruby
class Book < ActiveRecord::Base
  include Rql::Queryable

  derived_attr :leaves do
    pages / 2
  end
end
```

and use it in a query like this:
```ruby
Book.rql.where(leaves: 100)
```

or

```ruby
Book.rql.where{leaves > 100}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/liefni/rql.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
