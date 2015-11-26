json.emailLists @email_lists do |email_list|
  json.extract!(email_list, :name)
  json.url email_list_url(email_list)
  json.showUrl email_list_url(email_list)
end
json.count @count
json.filter @filter
json.newUrl new_email_list_url()
