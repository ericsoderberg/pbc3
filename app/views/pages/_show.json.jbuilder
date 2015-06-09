json.page do
  json.extract!(@page, :id, :name)
  json.page_elements @page.page_elements do |page_element|
    json.id page_element.id
    json.index page_element.index
    json.type page_element.element_type
    case page_element.element_type
    when 'Text'
      json.partial! 'texts/show', text: page_element.element
      json.editUrl edit_page_text_url(@page, page_element.element)
    when 'Event'
      json.partial! 'events/show', event: page_element.element
      json.editUrl edit_page_event_url(@page, page_element.element)
    end
  end
  if @edit_actions
    json.edit_actions do
      json.array! @edit_actions, :label, :url
    end
  end
end