class MaterialUploader < CarrierWave::Uploader::Base
  # include Cloudinary::CarrierWave

  # process :convert => 'png' # 画像の保存形式
  # process :tags => ['material'] # 保存時に添付されるタグ（管理しやすいように適宜変更しましょう）

  # process :resize_to_limit => [700, 700] # 任意でリサイズの制限

  # 保存する画像の種類をサイズ別に設定
  # version :standard do
  #   process :resize_to_fill => [100, 150, :north]
  # end

  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # def public_id
  #   return "local_test_cloudinary/" + Cloudinary::Utils.random_public_id;
  # end

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}__#{model.uuid}__#{mounted_as}/"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  def extension_whitelist
    %w(pdf)
  end

  def filename
    original_filename if original_filename
  end
end
