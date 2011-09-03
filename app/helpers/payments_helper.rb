module PaymentsHelper
  def payment_label_date(payment)
    if payment
      if payment.received_at
        l(payment.received_at.to_date, :format => :medium)
      elsif payment.sent_at
        l(payment.sent_at.to_date, :format => :medium)
      end
    end
  end
end
