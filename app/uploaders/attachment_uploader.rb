# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base
  delegate :identifier, to: :file, allow_nil: true
  storage :file

  def store_dir
    "#{Rails.root}/public/uploads/files/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end