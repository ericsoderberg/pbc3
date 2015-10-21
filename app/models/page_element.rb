class PageElement < ActiveRecord::Base
  belongs_to :page, required: true
  belongs_to :element, required: true, polymorphic: true
  validates :index, :uniqueness => {:scope => :page_id},
    :numericality => {:greater_than_or_equal_to => 1}
  # element can be in a page only once
  validates :element_id, :uniqueness => {:scope => :element_type}
  # element cannot be in two pages, except Page -> Page

  def self.page_ids_with_events_other_than(event)
    where('element_type = ? AND element_id != ?', 'Event', event.id).to_a.map{|pe| pe.page_id}
  end
end
