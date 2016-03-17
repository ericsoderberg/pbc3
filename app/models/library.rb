class Library < ActiveRecord::Base
  has_many :page_elements, as: :element, :dependent => :destroy
  has_many :pages, :through => :page_elements, :class_name => 'Page',
    :source => :page
  has_many :messages, -> { order('date DESC') }
  has_many :message_sets

  def self.sort()
    order('LOWER(libraries.name) ASC')
  end

end
