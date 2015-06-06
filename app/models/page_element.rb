class PageElement < ActiveRecord::Base
  belongs_to :page, required: true
  belongs_to :element, polymorphic: true
  validates :index, :uniqueness => {:scope => :page_id},
    :numericality => {:greater_than_or_equal_to => 1}
end
