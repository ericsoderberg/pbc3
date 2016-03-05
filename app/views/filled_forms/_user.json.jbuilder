json.formFills @filled_forms do |filled_form|
  json.extract!(filled_form, :id, :name, :created_at, :updated_at, :version)
  json.editPath edit_form_fill_path(@form, filled_form)
end
json.newPath new_form_fill_path(@form)

json.form do
  json.extract!(@form, :id, :name, :version)
end

if @page
  json.page do
    json.extract!(@page, :name)
    json.url friendly_page_path(@page)
  end
end
