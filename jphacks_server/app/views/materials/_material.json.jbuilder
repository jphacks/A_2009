json.extract! material, :id, :uuid, :url, :author, :password_digest, :title, :created_at, :updated_at
json.url material_url(material, format: :json)
