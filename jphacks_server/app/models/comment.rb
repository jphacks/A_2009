class Comment < ApplicationRecord
  belongs_to :material, class_name: "Material", foreign_key: "material_id"
end
