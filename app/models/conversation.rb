class Conversation < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  has_many :comments, -> { order('created_at ASC') }
  
  ###attr_protected :id
  
  validate :text, :presence => true
  validate :user, :presence => true
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
