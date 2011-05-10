class Author < ActiveRecord::Base
  has_many :message_sets
  has_many :messages, :order => 'date desc'
  acts_as_url :name, :sync_url => true
  
  validates :name, :presence => true
  
  def to_param
    url
  end
  
end
