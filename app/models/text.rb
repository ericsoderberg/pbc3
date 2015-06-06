class Text < ActiveRecord::Base
  has_many :page_elements, as: :element, :dependent => :destroy
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  searchable do
    text :text
  end
end
