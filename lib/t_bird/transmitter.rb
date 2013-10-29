# encoding: utf-8

require 'aws/s3'

module TBird
  class Transmitter
    def initialize
      @s3 = AWS::S3.new(access_key_id: Configuration.aws_key, secret_access_key: Configuration.aws_secret)
    end

    def transmit!(name, file, options = {})
      s3object = s3bucket.objects[name]
      s3object.write(file, default_options.merge(options))
      s3object.public_url(secure: true)
    end

    private

    def s3bucket
      @s3bucket ||= @s3.buckets[Configuration.aws_bucket]
    end

    def default_options
      { 
        acl: 'public-read',
        content_type: 'binary/octet-stream',
        metadata: {}
      }
    end
  end
end
