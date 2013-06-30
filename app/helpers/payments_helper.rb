module PaymentsHelper
  def payment_label_date(payment)
    if payment
      if payment.received_at
        payment.received_at.relative_str
      elsif payment.sent_at
        payment.sent_at.relative_str
      else
        payment.created_at.relative_str
      end
    end
  end
end
