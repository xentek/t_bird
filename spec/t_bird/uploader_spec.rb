# encoding: utf-8

require 'spec_helper'

describe TBird::Upload do
  include TBirdSpecData

  before do
    @tbird_upload = TBird::Upload.new(upload_file)
  end

  it "can return original filename" do
    @tbird_upload.original_filename.must_equal 'sample.jpg'
  end

  it "can return content type" do
    @tbird_upload.content_type.must_equal 'image/jpeg'
  end

  it "can return the original file binary data" do
    @tbird_upload.original_file.wont_be_nil
  end
end
