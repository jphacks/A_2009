json.set! :material do
  json.url material&.url.url
  json.author material&.author
  json.title material&.title
  json.uuid material&.uuid
end

json.comments do
  json.array! @comments do |comment|
    json.count comment.count
    json.number comment.number
    json.uuid comment.uuid
    json.text  comment.text
    json.material_uuid material.uuid
  end  
end