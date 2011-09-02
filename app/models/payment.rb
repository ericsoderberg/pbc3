class Payment < ActiveRecord::Base
  belongs_to :user
  has_many :filled_forms, :dependent => :nullify
  
  METHODS = ['check', 'online bank', 'paypal']
  
  validates :amount, :presence => true
  validates :sent_at, :presence => true
  validates :method, :presence => true, :inclusion => {:in => METHODS}
  
  composed_of :amount,
    :class_name => 'Money',
    :mapping => %w(amount cents),
    :constructor => Proc.new { |value|
      Money.new(value || 0, Money.default_currency) },
    :converter => Proc.new { |value|
      value.respond_to?(:to_money) ? value.to_money : Money.empty }
      
  composed_of :received_amount,
    :class_name => 'Money',
    :mapping => %w(received_amount cents),
    :constructor => Proc.new { |value|
      Money.new(value || 0, Money.default_currency) },
    :converter => Proc.new { |value|
      value.respond_to?(:to_money) ? value.to_money : Money.empty }
      
end
