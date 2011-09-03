module FilledFormsHelper
  
  def payment_label_date(filled_form)
    if filled_form.payment_received?
      l(filled_form.payment.received_at.to_date, :format => :medium)
    elsif filled_form.payment_sent?
      l(filled_form.payment.sent_at.to_date, :format => :medium)
    end
  end
  
end
