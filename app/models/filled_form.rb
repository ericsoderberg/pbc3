class FilledForm < ActiveRecord::Base
  belongs_to :form
  has_one :page, :through => :form, :source => :page
  belongs_to :user
  belongs_to :payment
  has_many :filled_fields, :autosave => true, :dependent => :destroy,
    :include => :form_field, :order => 'form_fields.form_index'
  
  validates :form, :presence => true
  validates :name, :presence => true
  validates :verification_key, :presence => true
  
  before_validation(:on => :create) do
    self.verification_key = SecureRandom.base64(48);
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
        end)
  end
  
  def payable?
    form.payable?
  end
  
  def payable_amount
    filled_fields.includes(:form_field).where('form_fields.monetary' => true).
      map{|ff| ff.payable_amount}.inject(0.to_money, :+)
  end
  
  def payable_fields
    filled_fields.where("form_fields.monetary = 't' AND " +
      "filled_fields.value IS NOT NULL AND " +
      "filled_fields.value != ''")
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
