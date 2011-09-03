class FilledForm < ActiveRecord::Base
  belongs_to :form
  belongs_to :user
  belongs_to :payment
  has_many :filled_fields, :autosave => true, :dependent => :destroy,
    :include => :form_field, :order => 'form_fields.form_index'
  
  validates :form, :presence => true
  validates :user, :presence => true
  validates :name, :presence => true
  
  def payable?
    form.payable?
  end
  
  def payable_amount
    filled_fields.includes(:form_field).where('form_fields.monetary' => true).map{|ff| ff.payable_amount}.inject(:+)
  end
  
  def payable_fields
    filled_fields.where("form_fields.monetary = 't' AND " +
      "filled_fields.value IS NOT NULL AND " +
      "filled_fields.value != ''")
  end
  
  def payment_state
    if payment
      if payment.received_amount > 0
        'received'
      else
        'sent'
      end
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
