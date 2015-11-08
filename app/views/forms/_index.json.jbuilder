json.forms @forms do |form|
  json.extract!(form, :id, :name)
  #json.editUrl edit_contents_form_url(form)
  #json.realEditUrl edit_form_url(form)
  json.formFillsUrl form_fills_url(form)
end
json.count @count
json.filter @filter
json.newUrl new_form_url()
