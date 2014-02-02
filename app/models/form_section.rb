class FormSection < ActiveRecord::Base
  belongs_to :form
  has_many :form_fields, -> { order('form_index ASC') },
    :autosave => true, :dependent => :destroy
    
  validates :form, :presence => true
    
  def copy(source_form_section)
    self.name = source_form_section.name
    source_form_section.form_fields.each do |source_field|
      new_field = self.form_fields.build
      new_field.form = self.form
      new_field.form_section = self
      new_field.copy(source_field)
    end
  end
end
