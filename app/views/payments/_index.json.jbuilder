json.payments @payments do |payment|
  json.extract!(payment, :id, :amount_cents, :method, :received_amount_cents,
    :received_at, :received_notes, :notes, :sent_at)
  json.editUrl edit_payment_url(payment)
end
json.count @count
json.filter @filter
# json.newUrl new_payment_url()
