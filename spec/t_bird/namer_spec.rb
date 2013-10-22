# encoding: utf-8

require 'spec_helper'

describe TBird::Namer do
  include TBirdSpecData
  before do
    @original_filename = Pathname.new(sample_file).basename.to_s
    @namer = TBird::Namer
  end

  it "returns the extension of the original filename" do
    @namer.new(@original_filename).ext.must_equal '.jpg'
  end

  it "returns the default identifier" do
    @namer.new(@original_filename).identifier.must_equal Digest::SHA1.hexdigest(@original_filename)
  end

  it "returns the specified identifier" do
    @namer.new(@original_filename, 1).identifier.must_equal 1
  end

  it "returns the generated token" do
    UUID.validate(@namer.new(@original_filename).token).must_equal true
  end

  it "returns the given token" do
    token = SecureRandom.uuid
    @namer.new(@original_filename, nil, token).token.must_equal token
  end

  it "returns the new name for 'original' version" do
    token = SecureRandom.uuid
    @namer.new(@original_filename, 1, token).new_name.must_equal "1/#{token}_original.jpg"
  end

  it "returns the new name for the given version" do
    token = SecureRandom.uuid
    @namer.new(@original_filename, 1, token).new_name('thumb').must_equal "1/#{token}_thumb.jpg"
  end
end
