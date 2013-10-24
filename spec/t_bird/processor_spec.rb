# encoding: utf-8

require 'spec_helper'

describe TBird::Processor do
  include TBirdSpecData

  before do
    @custom_process = ->(img) { img.quality 88 }
    @processor = TBird::Processor.new(upload_file)
  end

  it "can process an image" do
    image = @processor.process(&@custom_process)
    image.valid?.must_equal true
    image.destroy!
  end

  it "can thumbnail an image" do
    image = @processor.thumbnail
    image.valid?.must_equal true
    image.destroy!
  end

  it "can resize an image" do
    image = @processor.resize('300')
    image.valid?.must_equal true
    image.destroy!
  end

  it "can return the original image" do
    image = @processor.original
    image.valid?.must_equal true
    image.destroy!
  end

  it "can write image to a stream" do
    image = @processor.resize('x200')
    @processor.stream.must_be_instance_of StringIO
    image.destroy!
  end
end
