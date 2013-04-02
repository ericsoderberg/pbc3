class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  
  attr_protected :id
  
  validate :text, :presence => true
  validate :user, :presence => true
  
  def authorized?(user)
    conversation.authorized?(user)
  end
  
end
