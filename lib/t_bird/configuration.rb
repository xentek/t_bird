# encoding utf-8

module TBird
  class Configuration
    
    class << self
      attr_accessor :aws_key, :aws_secret, :aws_bucket, :thumbnail_size
    end

    def self.configure
      yield self
    end

    def self.thumbnail_size
      @thumbnail_size ||= 100
    end
  end
end
