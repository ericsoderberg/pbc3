class Payment < ActiveRecord::Base
  belongs_to :user
  has_many :filled_forms, :dependent => :nullify

  METHODS = ['check', 'PayPal']

  validates :amount, :presence => true
  validates :method, :presence => true, :inclusion => {:in => METHODS}
  validates :verification_key, :presence => true

  monetize :amount_cents
  monetize :received_amount_cents, :allow_nil => true

=begin
  ###
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
=end

  before_validation(:on => :create) do
    self.verification_key = SecureRandom.base64(48);
  end

  def name
    unless filled_forms.empty?
      form = filled_forms.first.form
      "payment for #{form.name}"
    end
  end

  def state
    if received_amount && received_at
      'received'
    elsif sent_at
      'sent'
    else
      'pending'
    end
  end

  def cancellable?
    state == 'pending'
  end

  def received?
    state == 'received'
  end

end
