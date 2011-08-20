class Payment < ActiveRecord::Base
  belongs_to :user
  has_many :filled_forms
  
  METHODS = ['check', 'credit card', 'online bank', 'online paypal']
  
  validates :amount, :presence => true
  validates :method, :presence => true, :inclusion => {:in => METHODS}
end
