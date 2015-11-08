form ||= @form
filled_forms = @filled_forms || form.filled_forms_for_user(current_user)

json.form do

  json.partial! 'forms/show', :form => form

  json.filled_forms filled_forms, partial: 'filled_forms/show', as: :filled_form

  json.createUrl form_fills_url(form)
  json.authenticityToken form_authenticity_token()

  if current_user and current_user.administrator?
    json.indexUrl form_fills_url(form)
    if @mode
      json.mode @mode
    end
  end

end
