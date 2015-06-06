text ||= @text
json.text do
  json.extract!(text, :text)
end
