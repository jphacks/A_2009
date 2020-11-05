class Material < ApplicationRecord
  has_secure_password
  mount_uploader :url, MaterialUploader

  has_many :comments, class_name: "Comment", dependent: :destroy
end
