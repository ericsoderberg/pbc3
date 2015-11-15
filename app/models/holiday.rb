class Holiday < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true, :uniqueness => true

  include Searchable
  search_on :name
end
