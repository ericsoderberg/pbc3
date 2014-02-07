class FilledForm < ActiveRecord::Base
  belongs_to :form
  has_one :page, :through => :form, :source => :page
  belongs_to :user
  belongs_to :payment
  has_many :filled_fields, -> {
    includes(:form_field).order('form_fields.form_index') },
    :autosave => true, :dependent => :destroy
  belongs_to :parent, :class_name => 'FilledForm'
  has_many :children, :class_name => 'FilledForm', :foreign_key => :parent_id,
    :dependent => :destroy
  
  validates :form, :presence => true
  validates :name, :presence => true
  validates :verification_key, :presence => true
  validate :required_fields_set
  validate :parent_if_form_parent
  
  before_validation(:on => :create) do
    self.verification_key = SecureRandom.base64(48);
  end
  
  def required_fields_set
    if form
      form.form_fields.each do |form_field|
        if form_field.required?
          filled_field = filled_fields.detect{|f| f.form_field_id == form_field.id}
          unless filled_field
            errors.add(form_field.name, "is required")
          end
        end
      end
    end
  end
  
  def parent_if_form_parent
    if form and form.parent and not self.parent
      errors.add(:parent, "is required")
    end
  end
  
  def self.for_user(user)
    user ? where(:user_id => user.id) : where(:user_id => false)
  end
  
  def self.possible_for_payment(payment)
    # always take filled forms for this payment
    # if we have a user, also take his unpaid filled forms
    includes(:form).where("forms.payable = 't' AND " +
        if payment.user_id
          "filled_forms.user_id = #{payment.user_id} AND " +
          "(filled_forms.payment_id IS NULL OR " +
            "filled_forms.payment_id = #{payment.id})"
        else
          "filled_forms.payment_id = #{payment.id}"
        end).references(:form)
  end
  
  def payable?
    form.payable?
  end
  
  def payable_amount
    payable_fields.map{|ff| ff.payable_amount}.inject(0.to_money, :+)
  end
  
  def payable_fields
    filled_fields.where("form_fields.monetary = 't'")
  end
  
  def payment_state
    if payment
      payment.state
    else
      'unpaid'
    end
  end
  
  def payment_received?
    'received' == payment_state
  end
  
  def payment_sent?
    'sent' == payment_state
  end
  
end
