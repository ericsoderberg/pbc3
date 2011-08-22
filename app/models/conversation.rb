class Conversation < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  has_many :comments, :order => 'created_at ASC'
  
  validate :text, :presence => true
  validate :user, :presence => true
end
