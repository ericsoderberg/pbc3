class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  
  validate :text, :presence => true
  validate :user, :presence => true
end
