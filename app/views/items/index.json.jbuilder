# json.page do
#   json.extract!(@page, :id, :name)
#   json.page_elements @page.page_elements do |page_element|
#     json.index page_element.index
#     json.type page_element.element_type
#     case page_element.element_type
#     when 'Text'
#       json.element do
#         json.extract!(page_element.element, :text)
#       end
#     end
#   end
# end
