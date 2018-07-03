require 'csv'

class Book < ApplicationRecord
  belongs_to :borrower, class_name: 'Member'
  belongs_to :author

  derive_attr :leaves do
    pages / 2
  end
end

author_ids_by_name = Author.pluck(:name, :id)
                       .group_by(&:first)
                       .map{|k,vs| [k,vs.first.last]}.to_h

member_ids_by_name = Member.pluck(:name, :id)
                       .group_by(&:first)
                       .map{|k,vs| [k,vs.first.last]}.to_h

CSV.foreach(File.expand_path('../books.csv', __FILE__)).each_with_index do |(name, author, member), i|
  next if i.zero?
  Book.create(
    name: name,
    pages: Random.rand(200..300),
    author_id: author_ids_by_name[author],
    borrower_id: member_ids_by_name[member]
  )
end