require 'csv'

class Author < ActiveRecord::Base

end

Author.create!(
  CSV.foreach(File.expand_path('../authors.csv', __FILE__), headers: true).map(&:to_hash)
)