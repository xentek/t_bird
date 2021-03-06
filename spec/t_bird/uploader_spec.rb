# encoding: utf-8

require 'spec_helper'

describe TBird::Uploader do
  include TBirdSpecData

  before do
    @uploader = TBird::Uploader.new(upload_file)
    @urls = ['https://s3.example.com/5a3f124f68b57512d3865da4c527f6b7bbd4173a/b54c0891-92a1-4641-8334-d396d5cc21c4_thumbnail.jpg',
             'https://s3.example.com/5a3f124f68b57512d3865da4c527f6b7bbd4173a/b54c0891-92a1-4641-8334-d396d5cc21c4_original.jpg']
  end

  it "can return the file" do
    @uploader.file.wont_be_nil
  end

  it "can return the options" do
    @uploader.options.must_equal({ identifier: nil, token: nil })
  end

  it "can return the metadata" do
    @uploader.metadata.must_equal({ acl: :public_read, content_type: 'image/jpeg', metadata: {} })
  end
  

  it "can return the content type" do
    @uploader.content_type.must_equal 'image/jpeg'
  end

  it "can return the original filename" do
    @uploader.original_filename.must_equal 'sample.jpg'
  end

  it "can return an instance of Processor" do
    @uploader.processor.must_be_instance_of TBird::Processor
  end
  
  it "can return an instance of Namer" do
    @uploader.namer.must_be_instance_of TBird::Namer
  end

  it "can return an instance of Transmitter" do
    @uploader.transmitter.must_be_instance_of TBird::Transmitter
  end

  it "can return the registered versions" do
    @uploader.versions.must_equal TBird::Uploader.versions
  end

  it "can upload all versions" do
    TBird::Transmitter.any_instance.stubs(:transmit!).returns(*@urls)
    @uploader.upload!.must_equal({ thumbnail: @urls.first, original: @urls.last })
  end

  it "can return the upload urls" do
    TBird::Transmitter.any_instance.stubs(:transmit!).returns(*@urls)
    
    @uploader.upload!
    @uploader.uploads.must_equal({ thumbnail: @urls.first, original: @urls.last })
  end
end
