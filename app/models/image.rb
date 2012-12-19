class Image < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_accessible :caption, :location, :original
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :original


  def to_jq_upload
    [{
      name: original_file_name,
      size: original_file_size,
      url: edit_admin_image_path(self),
      thumbnail_url: original.url,
      delete_url: admin_image_path(self),
      delete_type: 'DELETE',
     }]
  end
end
