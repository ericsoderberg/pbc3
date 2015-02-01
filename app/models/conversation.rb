class Conversation < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  has_many :comments, -> { order('created_at ASC') }
  
  validates :text, :presence => true
  validates :user, :presence => true
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
