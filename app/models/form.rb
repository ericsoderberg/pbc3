class Form < ActiveRecord::Base
  belongs_to :page
  has_many :form_fields, :order => 'index ASC',
    :autosave => true, :dependent => :destroy
  has_many :filled_forms, :order => 'name ASC', :dependent => :destroy
  acts_as_audited
  
  validates :name, :presence => true
  
  def possible_pages
    Page.order('name')
  end
  
  def visible_filled_forms(user)
    return filled_forms if user.administrator?
    filled_forms.where('user_id = ?', user.id)
  end
  
  def order_fields(ids)
    result = true
    FormField.transaction do
      tmp_fields = FormField.find(ids)
      ids.each_with_index do |id, i|
        field = tmp_fields.detect{|ff| id == ff.id}
        field.index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless field.save(:validate => false)
      end
    end
    result
  end
  
  def build_fill()
    filled_form = filled_forms.new
    form_fields.each do |form_field|
      filled_field = filled_form.filled_fields.build
      filled_field.form_field = form_field
      filled_field.value = ''
    end
    filled_form
  end
  
  def copy(source_form)
    source_form.form_fields.each do |source_form_field|
      new_form_field = self.form_fields.build
      new_form_field.form = self
      new_form_field.copy(source_form_field)
    end
  end
  
end
