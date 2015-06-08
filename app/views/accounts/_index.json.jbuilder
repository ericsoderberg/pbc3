json.users @users do |user|
  json.extract!(user, :id, :email, :first_name, :last_name)
  json.url account_url(user)
end
json.count @count
json.filter @filter
