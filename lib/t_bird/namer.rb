# encoding: utf-8

require 'digest/sha1'
require 'pathname'

module TBird
  class Namer
    attr_reader :ext, :identifier, :token
    def initialize(original_filename, identifier = nil, token = SecureRandom.uuid)
      @ext = Pathname.new(original_filename).extname
      @identifier = identifier || Digest::SHA1.hexdigest(original_filename)
      @token = token
    end

    def new_name(version = 'original')
      "#{identifier}/#{token}_#{version}#{ext}"
    end
  end
end
