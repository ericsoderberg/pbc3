class MessageSet < ActiveRecord::Base
  belongs_to :author
  has_many :messages
  acts_as_url :title
  
  validates :title, :presence => true
  
  def to_param
    url
  end
  
end
