json.set! :comment do
  json.count @comment.count
  json.number @comment.number
  json.uuid @comment.uuid
  json.text  @comment.text
  json.material_uuid material.uuid
end