class Author < ActiveRecord::Base
  has_many :message_sets
  has_many :messages
  acts_as_url :name
  
  validates :name, :presence => true
  
  def to_param
    url
  end
  
end
