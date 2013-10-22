# encoding: utf-8

ENV['RACK_ENV'] = 'test'

lib_path = File.expand_path('../../lib', __FILE__)
($:.unshift lib_path) unless ($:.include? lib_path)

Bundler.setup(:default, ENV['RACK_ENV'])

require 't_bird'

require 'minitest/autorun'
require 'minitest/reporters'

MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

require 'mocha/setup'
require 'rack/test'
#include Rack::Test::Methods

require 'uuid'

module TBirdSpecData
  def sample_file
    File.expand_path('../sample.jpg', __FILE__)
  end

  def upload_file
    Rack::Test::UploadedFile.new(sample_file, 'image/jpeg')
  end

  def upload_filedata
    upload_file.read
  end
end
