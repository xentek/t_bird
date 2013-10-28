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

    @stored_filename = '1/sample_original.jpg'
    @upload = upload_file
    @opts = { acl: :public_read, content_type: 'image/jpeg', metadata: {} }
    @aws_config = stub_everything('aws_config')
    @s3object = stub(public_url: "https://bucket.s3.amazonaws.com/#{@stored_filename}")    
    @bucket = mock('bucket').responds_like(AWS::S3::Bucket.new(TBird::Configuration.aws_bucket, config: @aws_config))
    @bucket_collection = { TBird::Configuration.aws_bucket => @bucket }
  end

  it "can connect to s3" do
    AWS::S3.expects(:new).with(access_key_id: TBird::Configuration.aws_key, secret_access_key: TBird::Configuration.aws_secret)
    TBird::Transmitter.new 
  end

  it "can select s3 bucket" do
    AWS::S3::BucketCollection.expects(:new).returns(@bucket_collection)
    TBird::Transmitter.new.send(:s3bucket)
  end

  it "can transmit file to s3" do
    @bucket.expects(:objects).returns({ @stored_filename => @s3object })
    @s3object.expects(:write).with(@upload, { acl: :public_read, content_type: 'image/jpeg', metadata: {} }).returns(@s3object)
    AWS::S3.stubs(:new).returns(stub(buckets: @bucket_collection))
    TBird::Transmitter.new.transmit!(@stored_filename, @upload, { content_type: 'image/jpeg' }).must_equal "https://bucket.s3.amazonaws.com/1/sample_original.jpg"
  end
end
