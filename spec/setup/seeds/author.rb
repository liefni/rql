require 'csv'

class Author < ApplicationRecord
  has_many :books

  derive_attr :total_pages do
    books.sum(:pages)
  end

  derive_attr :total_pages do
    books.sum(:pages)
  end

  derive_attr :total_books do
    books.count
  end

  derive_attr :total_a_book_pages do
    books.rql.where{name.starts_with?('a')}.sum(:pages)
  end
end

Author.create!(
  CSV.foreach(File.expand_path('../authors.csv', __FILE__), headers: true).map(&:to_hash)
)