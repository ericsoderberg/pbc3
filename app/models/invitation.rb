class Invitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  ###attr_protected :id
  
  RESPONSES = ['yes', 'no', 'maybe', 'unknown']
  
  validates :email, :presence => true,
    :uniqueness => {:scope => :event_id}
  validates :response, :presence => true, :inclusion => {:in => RESPONSES}
  validates :key, :presence => true, :uniqueness => {:scope => :event_id}
    
  before_validation(:on => :create) do
    self.key = UUIDTools::UUID.random_create.to_s
    self.user = User.find_by_email(self.email)
    true
  end
  
end
