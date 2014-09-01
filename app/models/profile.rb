class Profile < User

  mount_uploader :portrait, PortraitUploader
  # crop_uploaded :portrait

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :crop_portrait

  def crop_portrait
    portrait.recreate_versions! if crop_x.present?
  end

end
