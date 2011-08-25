class Author < ActiveRecord::Base
  has_many :message_sets
  has_many :messages, :order => 'date desc'
  acts_as_url :name, :sync_url => true
  
  validates :name, :presence => true
  
  searchable do
    text :name, :default_boost => 2
  end
  
  def authorized?(user)
    true
  end
  
  def to_param
    url
  end
  
  def first_year
    messages.empty? ? Date.today.year : messages.last.date.year
  end
  
  def last_year
    messages.empty? ? Date.today.year : messages.first.date.year
  end
  
  def yearly_density
    messages.count.to_f / ([1, (last_year - first_year)].max)
  end
  
end
