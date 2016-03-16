class Library < ActiveRecord::Base
  has_many :messages, -> { order('date DESC') }
  has_many :message_sets

  def self.sort()
    order('LOWER(libraries.name) ASC')
  end

end
