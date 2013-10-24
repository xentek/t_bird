# encoding: utf-8

require 'spec_helper'

describe TBird::Transmitter do
  include TBirdSpecData
  before do
    TBird::Configuration.configure do |config|
      config.aws_key = 'abc'
      config.aws_secret = '123'
      config.aws_bucket = 'bucket'
    end
    
    keys = { access_key_id: TBird::Configuration.aws_key,
             secret_access_key: TBird::Configuration.aws_secret,
             use_ssl: true }

    AWS::S3::S3Object.stubs(:connected?).returns(true)
    AWS::S3::Base.stubs(:establish_connection!).with(keys)
    AWS::S3::Service.stubs(response: stub(:success? => true))

    @stored_filename = '1/sample_original.jpg'
    @upload = upload_file
    @transmitter = TBird::Transmitter.new(@stored_filename, @upload, { content_type: 'image/jpeg' })
  end

  it "transmit file to store" do
    AWS::S3::S3Object.expects(:store).with(@stored_filename, @upload, 'bucket', {:access => :public_read, :content_type => 'image/jpeg'})
    @transmitter.transmit!
  end

  it "can return the S3 url for the file uploaded" do
    AWS::S3::S3Object.expects(:url_for).with(@stored_filename, 'bucket', authenticated: false, use_ssl: true)
    @transmitter.url
  end
end
