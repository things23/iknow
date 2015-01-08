json.(@answer, :id, :body)

json.user @answer.user, :email

json.attachments @answer.attachments do |a|
  json.filename a.file.identifier
  json.url a.file.url
end