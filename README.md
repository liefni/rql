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

Define a derived attribute in your model:
```ruby
class Book < ActiveRecord::Base
  include Rql::Queryable

  derived_attr :leaves do
    pages / 2
  end
end
```

then use it in a query:
```ruby
Book.rql.where(leaves: 100)
```

or using the dsl

```ruby
Book.rql.where{leaves > 100}
```

### Aggregate Functions

Aggregate functions can be used in derived attributes:

```ruby
class Author < ActiveRecord::Base
  include Rql::Queryable
  
  has_many :books
  
  derive_attr :total_books do
    books.count
  end
  
  derive_attr :total_pages do
    books.sum(:page)
  end
  
  derive_attr :long_books do
    books.rql.where{pages > 300}.count
  end
end
```

### Preloading

Derived attributes can be preloaded from the database database to prevent multiple calls to the database when accessing 
derived attributes that use associated models. To preload derived attributes:

```ruby
Authors.derive(:total_books, :total_pages)
```

If a derived attribute has not been preloaded then the code will be evaluated in the context of the model when it is
accessed. For instance calling `Book.first.leaves` will return `pages / 2` just as a normal method would, without having
to query the database.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can 
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the 
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/liefni/rql. This project is intended to be a 
safe, welcoming space for collaboration, and contributors are expected to adhere to the 
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
