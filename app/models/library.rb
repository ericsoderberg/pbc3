class Library < ActiveRecord::Base
  has_many :messages, :order => 'date ASC'
  has_many :message_sets
end
