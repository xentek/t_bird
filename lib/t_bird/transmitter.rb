# encoding: utf-8

require 'aws/s3'

module TBird
  class Transmitter
    include AWS::S3
    attr_reader :name, :file, :metadata
    def initialize(name, file, metadata = {})
      @name = name
      @file = file
      @metadata = default_metadata.merge(metadata)
    end

    def transmit!
      connect!
      @tranmission = S3Object.store(name, file, Configuration.aws_bucket, metadata)
    end

    def url
      @transmission.url
    end

    private

    def connect!
      Base.establish_connection!(access_key_id: Configuration.aws_key, secret_access_key: Configuration.aws_secret, use_ssl: true)
    end

    def default_metadata
      {
        access: :public_read,
        content_type: 'binary/octet-stream'
      }
    end
  end
end
