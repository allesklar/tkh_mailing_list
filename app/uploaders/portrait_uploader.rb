class PortraitUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  storage :file
  def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"  --- that was the suggested one
    "system/portraits/#{model.class.to_s.underscore}/#{model.id}"
  end

  # this is used by jcrop as a source photo
  # better not modify this code.
  version :xl do
    process resize_to_limit: [550, 550]
  end
  # these 4 vorsions are cropped square by the user
  version :thumbnail do
    process :crop
    resize_to_fill(125,125)
  end
  version :small do
    process :crop
    resize_to_fill(225, 225)
  end
  version :medium do
    process :crop
    resize_to_fill(350, 350)
  end
  version :large do
    process :crop
    resize_to_fill(450, 450)
  end
  # version(:xxl) { process :resize_to_limit => [900, 900] }

  def crop
    if model.crop_x.present?
      resize_to_limit(550, 550)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # got this from http://stackoverflow.com/questions/9561641/carrierwave-temp-directory-set-to-uploads-tmp-folder
  # without this all tmp files would go to /public/uploads/tmp which is not cool at all.
  def cache_dir
    # should return path to cache dir
    Rails.root.join 'tmp/uploads'
  end

end
