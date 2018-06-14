require 'csv'

class Member < ApplicationRecord
  has_many :books
end

Member.create!(
  CSV.foreach(File.expand_path('../members.csv', __FILE__), headers: true).map(&:to_hash)
)