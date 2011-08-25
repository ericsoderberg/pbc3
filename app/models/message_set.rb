class MessageSet < ActiveRecord::Base
  belongs_to :author
  has_many :messages, :order => 'date ASC', :dependent => :destroy
  acts_as_url :title, :sync_url => true
  
  validates :title, :presence => true
  
  searchable do
    text :title, :default_boost => 2
  end
  
  def authorized?(user)
    true
  end
  
  def to_param
    url
  end
  
  def ends_within?(start_date, end_date)
    messages.last.date < end_date
  end
  
  def self.between(start_date, end_date)
    MessageSet.includes(:messages).
      where('messages.date' => start_date..end_date)
  end
  
end
