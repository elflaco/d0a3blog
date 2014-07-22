# encoding: utf-8
class ResourceUploader < CarrierWave::Uploader::Base

 include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # def default_url
  #   "/assets/" + [version_name, "default.png"].compact.join('_')
  # end

  version :large do
    resize_to_limit(900, 600)
  end

  version :medium do
    resize_to_limit(600, 400)
  end

  version :thumb do
    process :crop_resource
    # resize_to_fill(300, 200)
  end

  def crop_resource
    if model.crop_x.present?
      resize_to_limit(300,200)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

end