edit ||= false
json.extract!(@page, :id, :name)
json.pageElements @page.page_elements do |page_element|
  json.extract!(page_element, :id, :index, :full, :color)
  json.type page_element.element_type
  case page_element.element_type
  when 'Text'
    json.text do
      json.partial! 'texts/show', text: page_element.element
    end
    if edit
      json.editUrl edit_page_text_url(@page, page_element.element)
    end
  when 'Item'
    json.item do
      json.partial! 'items/show', item: page_element.element
    end
    if edit
      json.editUrl edit_page_item_url(@page, page_element.element)
    end
  when 'Event'
    json.event do
      json.partial! 'events/show', event: page_element.element
    end
    if edit
      json.editUrl edit_event_url(page_element.element, {:page_id => @page.id})
    end
  when 'Page'
    json.partial! 'page_elements/show_page', page: page_element.element
    if edit
      json.editUrl edit_page_element_url(@page, page_element)
    end
  when 'Form'
    form = page_element.element
    json.form do
      json.partial! 'forms/show', :form => form
    end
    json.partial! 'filled_forms/page_index', form: form, page: @page
    if edit
      json.editUrl edit_contents_form_url(page_element.element,
        {:page_id => @page.id})
    end
  when 'Library'
    json.library do
      json.partial! 'libraries/show', library: page_element.element
    end
    if edit
      json.editUrl edit_library_url(page_element.element, {:page_id => @page.id})
    end
  end
end
if @edit_url
  json.editUrl @edit_url
end
if @back_page
  json.backPage do
    json.name @back_page.name
    json.url friendly_page_url(@back_page)
    json.path friendly_page_path(@back_page)
  end
end
