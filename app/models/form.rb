class Form < ActiveRecord::Base
  belongs_to :page
  has_many :form_fields, :order => 'form_index ASC',
    :autosave => true, :dependent => :destroy
  has_many :filled_forms, :order => 'name ASC', :dependent => :destroy
  acts_as_audited
  
  validates :name, :presence => true
  validates :page, :presence => true
  
  searchable do
    text :name, :default_boost => 2
  end
  
  def authorized?(user)
    page.authorized?(user)
  end
  
  def visible?(user)
    authorized?(user) and (published? or page.administrator?(user))
  end
  
  def possible_pages
    Page.order('name')
  end
  
  def visible_filled_forms(user)
    return filled_forms if page.administrator?(user)
    filled_forms.where('user_id = ?', user.id)
  end
  
  def order_fields(ids)
    result = true
    FormField.transaction do
      tmp_fields = FormField.find(ids)
      ids.each_with_index do |id, i|
        field = tmp_fields.detect{|ff| id == ff.id}
        field.form_index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless field.save(:validate => false)
      end
    end
    result
  end
  
  def create_default_fields
    form_fields.create({:field_type => FormField::INSTRUCTIONS,
      :form_index => 1, :name => "Instructions",
      :help => "Please change this to say something helpful"}) and
    form_fields.create({:field_type => FormField::FIELD,
      :form_index => 2, :name => "Name"}) and
    form_fields.create({:field_type => FormField::FIELD,
      :form_index => 3, :name => "Email"})
  end
  
  def build_fill()
    filled_form = filled_forms.new
    form_fields.each do |form_field|
      filled_field = filled_form.filled_fields.build
      filled_field.form_field = form_field
      filled_field.value = ''
      if FormField::SINGLE_CHOICE == form_field.field_type and
        not form_field.form_field_options.empty?
        filled_field.value = form_field.form_field_options.first.name
      end
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
