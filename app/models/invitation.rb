class Invitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
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
  
  # summarize the invitations by response
  def self.summarize(invitations)
    result = {}
    RESPONSES.each{|r| result[r] = 0}
    invitations.each do |i|
      result[i.response] += 1
    end
    result
  end
  
  def self.possible_responses
    RESPONSES
  end
  
end
