json.email_addresses @email_addresses do |email_address|
  json.email_address email_address
  json.removeUrl remove_email_list_url(@email_list, :email_address => email_address)
  json.authenticityToken form_authenticity_token()
end
json.count @count
json.filter @filter
json.newUrl subscribe_email_list_url(@email_list)

json.emailList do
  json.name @email_list.name
end
