json.newsletters @newsletters do |newsletter|
  json.extract!(newsletter, :id, :name, :published_at)
  json.url newsletter_url(newsletter)
  json.editUrl edit_newsletter_url(newsletter)
end
json.count @count
json.filter @filter
json.newUrl new_newsletter_url()
