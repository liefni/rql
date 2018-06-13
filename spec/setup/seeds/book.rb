require 'csv'

class Book < ActiveRecord::Base

end

author_ids_by_name = Author.pluck(:name, :id)
                       .group_by(&:first)
                       .map{|k,vs| [k,vs.first.last]}.to_h

CSV.foreach(File.expand_path('../books.csv', __FILE__), headers: true).each_with_index do |(name, author), i|
  next if i.zero?
  Book.create(
    name: name,
    pages: Random.rand(200..300),
    author_id: author_ids_by_name[author]
  )
end