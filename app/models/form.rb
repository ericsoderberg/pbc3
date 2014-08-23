class Form < ActiveRecord::Base
  belongs_to :page
  belongs_to :event
  has_many :form_fields, -> { order('form_index ASC') },
    :autosave => true, :dependent => :destroy
  has_many :form_sections, -> { order('form_index ASC') },
    :autosave => true, :dependent => :destroy
  has_many :filled_forms, -> { order('name ASC') }, :dependent => :destroy
  belongs_to :parent, :class_name => 'Form'
  has_many :children, :class_name => 'Form', :foreign_key => :parent_id
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  validates :name, :presence => true
  validates :page, :presence => true
  validates :version, :presence => true,
    numericality: { only_integer: true, greater_than: 0 }
  
  searchable do
    text :name, :default_boost => 2
  end
  
  after_initialize do
    self.pay_by_check = true if self.pay_by_check.nil?
    self.pay_by_paypal = true if self.pay_by_paypal.nil?
  end
  
  def authorized?(user)
    page.authorized?(user)
  end
  
  def searchable?(user)
    page.searchable?(user)
  end
  
  def visible?(user)
    authorized?(user) and (published? or page.administrator?(user))
  end
  
  def possible_pages
    Page.order('name')
  end
  
  def columns
    form_fields.valued.map{|ff| ff.name} +
    %w{user email} +
    (payable ? %w{state payment date} : [])
  end
  
  def visible_filled_forms(user)
    return filled_forms.where('filled_forms.id IS NOT null') if page.administrator?(user)
    return FilledForm.none unless user
    filled_forms.where('filled_forms.id IS NOT null AND filled_forms.user_id = ?', user.id)
  end
  
  def filled_forms_for_user(user)
    return FilledForm.none unless user
    filled_forms.where('user_id = ?', user.id)
  end
  
  def payments_for_user(user)
    return Payment.none unless user
    Payment.where('payments.user_id = ?', user.id).includes(:filled_forms).
      where('filled_forms.form_id = ?', self.id).references(:filled_forms)
  end
  
  def next_index
    return form_fields.count + form_sections.count + 1
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
  
  def order_sections(ids)
    result = true
    FormSection.transaction do
      tmp_sections = FormSection.find(ids)
      ids.each_with_index do |id, i|
        section = tmp_sections.detect{|fs| id == fs.id}
        section.form_index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless section.save(:validate => false)
      end
    end
    result
  end
  
  def create_default_fields
    Form.transaction do
      section = form_sections.create({form_index: 1, name: ''})
      section.save!
      section.form_fields.create({:field_type => FormField::INSTRUCTIONS,
        :form => section.form, :form_index => 2, :name => "Instructions",
        :help => "Please change this to say something helpful"}) and
      section.form_fields.create({:field_type => FormField::SINGLE_LINE,
        :form => section.form, :form_index => 3, :name => "Name"}) and
      section.form_fields.create({:field_type => FormField::SINGLE_LINE,
        :form => section.form, :form_index => 4, :name => "Email"})
      section.save!
    end
  end
  
  def migrate
    if form_sections.empty?
      Form.transaction do
        section = form_sections.create({form_index: 1, name: ''})
        section.save!
        form_fields.each do |f|
          f.migrate
          section.form_fields << f
        end
        section.save!
      end
    end
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
    if source_form.form_sections.count > 1
      source_form.form_sections.each do |source_form_section|
        new_form_section = self.form_sections.build
        new_form_section.form = self
        new_form_section.copy(source_form_section)
      end
    else
      source_form.form_fields.each do |source_form_field|
        new_form_field = self.form_fields.build
        new_form_field.form = self
        new_form_field.copy(source_form_field)
      end
    end
  end
  
end
