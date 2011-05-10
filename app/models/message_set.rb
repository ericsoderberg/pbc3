class MessageSet < ActiveRecord::Base
  belongs_to :author
  has_many :messages, :order => 'date ASC', :dependent => :destroy
  acts_as_url :title, :sync_url => true
  
  validates :title, :presence => true
  
  def to_param
    url
  end
  
end
