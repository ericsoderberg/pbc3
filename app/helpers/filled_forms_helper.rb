module FilledFormsHelper
  require 'csv'
  
  def header_values(form, value_form_fields)
    value_form_fields.map{|ff| ff.name} +
    %w{user email} +
    (form.payable ? %w{state payment date} : [])
  end
  
  def filled_form_values(form, value_form_fields, filled_form)
    value_form_fields.map{|ff|
      filled_field = filled_form.filled_fields.detect{|fff|
        ff == fff.form_field}
      filled_field ? filled_field.text_value : ''} +
    (filled_form.user ?
      [filled_form.user.name, filled_form.user.email]
      : ['anonymous', '']) +
    (form.payable? ?
      (filled_form.payment ?
        [filled_form.payment.state, filled_form.payment.method,
          (filled_form.payment.sent_at ?
            filled_form.payment.sent_at.strftime("%m/%d/%Y") : '')]
        : ['unpaid', '', ''])
      : [])
  end
  
  def output_csv
    
    parent_form_fields = @form.parent ? @form.parent.form_fields.valued : nil
    value_form_fields = @form.form_fields.valued

    ((@form.parent ? header_values(@form.parent, parent_form_fields) : []) +
      header_values(@form, value_form_fields)).to_csv + "\r\n" +
    (@filled_forms.map do |filled_form|
      (if @form.parent
        filled_form_values(@form.parent, parent_form_fields, filled_form.parent)
      else [] end +
      filled_form_values(@form, value_form_fields, filled_form)
      ).to_csv
    end.join("\r\n"))
  end
  
  def autocomplete_honeypot
    request.env['HTTP_USER_AGENT'].downcase.index('chrome/') or
    request.env['HTTP_USER_AGENT'].downcase.index('safari/')
  end
  
  def form_fill_timestamp
    @filled_form.updated_at.strftime("%B ") + @filled_form.updated_at.mday.ordinalize + @filled_form.updated_at.strftime(", %Y")
  end
end
