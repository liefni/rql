# RQL [![Build Status](https://secure.travis-ci.org/liefni/rql.svg)](http://travis-ci.org/liefni/rql) [![Gem Version](https://badge.fury.io/rb/rql.svg)](https://badge.fury.io/rb/rql)

RQL is a DSL for ActiveRecord designed to allow derived/calculated attributes on models to be used in database queries.

[Api Documentation](https://www.rubydoc.info/gems/rql/)

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

### Preloading/Eager-Loading

Derived attributes can be preloaded to prevent multiple database calls when
deriving attributes that reference associated models. To preload derived attributes:

```ruby
Authors.derive(:total_books, :total_pages)
```

If a derived attribute has not been preloaded then the code will be evaluated in the context of the model when it is
accessed. For instance calling `Book.first.leaves` will return `pages / 2` just as a normal method would, without having
to query the database.

### Query DSL

#### Operators

|Operator  |Example                               |SQL (In Postgres)                                       |
|----------|--------------------------------------|--------------------------------------------------------|
|==        |` Book.rql.where {pages == 200}`      |`SELECT * FROM "book" WHERE "book"."pages" = 200`       |
|===       |`Book.rql.where {pages === (200..300)}`|`SELECT * FROM "book" WHERE "book"."pages" >= 200 AND "book"."pages" >= 200` |
|>         |`Book.rql.where {pages > 200}`        |`SELECT * FROM "book" WHERE "book"."pages" > 200`       |
|<         |`Book.rql.where {pages < 200}`        |`SELECT * FROM "book" WHERE "book"."pages" < 200`       |
|>=        |`Book.rql.where {pages >= 200}`       |`SELECT * FROM "book" WHERE "book"."pages" >= 200`      |
|<=        |`Book.rql.where {pages <= 200}`       |`SELECT * FROM "book" WHERE "book"."pages" <= 200`      |
|+         |`Book.rql.where {pages + 2 == 200}`   |`SELECT * FROM "book" WHERE ("book"."pages" + 2) = 200` |
|-         |`Book.rql.where {pages - 2 == 200}`   |`SELECT * FROM "book" WHERE ("book"."pages" - 2) = 200` |
|*         |`Book.rql.where {pages * 2 == 200}`   |`SELECT * FROM "book" WHERE "book"."pages" * 2 = 200`   |
|/         |`Book.rql.where {pages / 2 == 200}`   |`SELECT * FROM "book" WHERE "book"."pages" / 2 = 200`   |
|\|        |`Book.rql.where {(pages == 200) \| (pages == 300)}` |`SELECT * FROM "book" WHERE ("book"."pages" = 200) OR ( "book"."pages" = 300)`|
|&         |`Book.rql.where {(pages == 200) & (pages == 300)}` |`SELECT * FROM "book" WHERE "book"."pages" = 200 AND  "book"."pages" = 300` |

#### Functions

|Function      |Example                                   |SQL (In Postgres)                                       |
|--------------|------------------------------------------|--------------------------------------------------------|
|`start_with?` |`Book.rql.where {name.start_with?('A')}`  |`SELECT * FROM "book" WHERE "book"."name" ILIKE 'A%'`   |
|`end_with?`   |`Book.rql.where {name.end_with?('A')}`    |`SELECT * FROM "book" WHERE "book"."name" ILIKE '%A'`   |
|`include?`    |`Book.rql.where {name.include?('A')}`     |`SELECT * FROM "book" WHERE "book"."name" ILIKE '%A%'`  |
|`in? `        |`Book.rql.where {name.in?(['A', 'B'])}`   |`SELECT * FROM "book" WHERE "book"."name" IN ('A', 'B')`|

|Aggregates                       |Example                                                   |
|---------------------------------|----------------------------------------------------------|
|`calculate(attribute, operation)`|`Author.rql.where {books.calculate(:pages, :sum) > 500}`  |
|`sum(attribute)`                 |`Author.rql.where {books.sum(:pages) > 500}`              |
|`average(attribute)`             |`Author.rql.where {books.average(:pages) > 250}`          |
|`minimum(attribute)`             |`Author.rql.where {books.minimum(:pages) > 300}`          |
|`maximum(attribute)`             |`Author.rql.where {books.maximum(:pages) > 200}`          |
|`count(attribute)`               |`Author.rql.where {books.count(:name) > 5}`               |
|`count`                          |`Author.rql.where {books.count > 5}`                      |

#### Order

|Order          |Example                             |SQL (In Postgres)                                       |
|---------------|------------------------------------|--------------------------------------------------------|
|asc            |`Book.rql.order {name.asc}`         |`SELECT * FROM "book" ORDER BY "book"."name" ASC`       |
|desc           |`Book.rql.order {name.desc}`        |`SELECT * FROM "book" ORDER BY "book"."name" DESC`      |
|asc(flag)      |`Book.rql.order {name.asc(false)}`  |`SELECT * FROM "book" ORDER BY "book"."name" DESC`      |
|desc(flag)     |`Book.rql.order {name.desc(false)}` |`SELECT * FROM "book" ORDER BY "book"."name" ASC`       |

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
