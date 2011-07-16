class Holiday < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :date, :presence => true, :uniqueness => true
end
