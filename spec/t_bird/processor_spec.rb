# encoding: utf-8

require 'spec_helper'

describe TBird::Processor do
  include TBirdSpecData

  before do
    @custom_process = ->(img) { img.quality 88 }
    @processor = TBird::Processor.new(upload_file[:tempfile])
  end

  it "can process an image" do
    @processor.process(&@custom_process)
    @processor.image.valid?.must_equal true
    @processor.image.destroy!
  end

  it "can thumbnail an image" do
    @processor.thumbnail
    @processor.image.valid?.must_equal true
    @processor.image.destroy!
  end

  it "can resize an image" do
    @processor.resize('300')
    @processor.image.valid?.must_equal true
    @processor.image.destroy!
  end

  it "can return the original image" do
    @processor.original
    @processor.image.valid?.must_equal true
    @processor.image.destroy!
  end

  it "can write image" do
    @processor.resize('x200')
    klass = (jruby?) ? Tempfile : File
    @processor.write_to_file.must_be_instance_of klass
    @processor.image.destroy!
  end
end
