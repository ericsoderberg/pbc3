json.forms @forms do |form|
  json.extract!(form, :id, :name)
  #json.editUrl edit_contents_form_url(form)
  #json.realEditUrl edit_form_url(form)
  json.formFillsPath form_fills_path(form)
end
json.count @count
json.filter @filter
json.newUrl new_form_url()
