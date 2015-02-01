class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  
  validates :text, :presence => true
  validates :user, :presence => true
  
  def authorized?(user)
    conversation.authorized?(user)
  end
  
end
