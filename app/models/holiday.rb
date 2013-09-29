class Holiday < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true, :uniqueness => true
end
