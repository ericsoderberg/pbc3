class FilledField < ActiveRecord::Base
  belongs_to :filled_form
  belongs_to :form_field
  
  validates :filled_form, :presence => true
  validates :form_field_id, :presence => true,
    :uniqueness => {:scope => :filled_form_id}
end
