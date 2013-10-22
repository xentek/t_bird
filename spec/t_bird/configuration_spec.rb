# encoding: utf-8

require 'spec_helper'

describe TBird::Configuration do
  before do
    TBird::Configuration.configure do |config|
      config.aws_key = 'access_key_id'
      config.aws_secret = 'secret_access_key'
      config.aws_bucket = 'bucket_name'
      config.thumbnail_size = 200
    end
  end

  it "can configure :aws_key" do
    TBird::Configuration.aws_key.must_equal 'access_key_id'
  end

  it "can configure :aws_secret" do
    TBird::Configuration.aws_secret.must_equal 'secret_access_key'
  end

  it "can configure :aws_bucket" do
    TBird::Configuration.aws_bucket.must_equal 'bucket_name'
  end
  it "can configure :thumbnail_size" do
    TBird::Configuration.thumbnail_size.must_equal 200
  end
end
