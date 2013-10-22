# encoding: utf-8

require 'spec_helper'

describe TBird::Processor do
  include TBirdSpecData

  before do
    @custom_process = Proc.new do |magick|
                        magick.resize '50%'
                        magick.quality 88
                      end

    @processor = TBird::Processor.new(upload_file)
    @versions = {
                  thumb: '90x90',
                  medium: '300',
                  large: 'x300',
                  custom: @custom_process
                }
  end

  it "can process an image" do
    image = @processor.process(&@custom_process)
    image.write StringIO.new
    image.valid?.must_equal true
    image.destroy!
  end

  it "can process image into a thubnail" do
    image = @processor.thumbnail
    image.write StringIO.new
    image.valid?.must_equal true
    image.destroy!
  end

  it "can resize an image" do
    image = @processor.resize('300')
    image.write StringIO.new
    image.valid?.must_equal true
    image.destroy!
  end
end
