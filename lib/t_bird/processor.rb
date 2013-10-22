# encoding: utf-8

require 'mini_magick'

module TBird
  class Processor
    attr_reader :image, :thumbnail_size
    def initialize(file_blob)
      @image = MiniMagick::Image.read(file_blob)
      @thumbnail_size = Configuration.thumbnail_size
    end

    def process(&block)
      image.combine_options do |magick|
        block.call(magick) if block_given?
      end
      image
    end

    def resize(size)
      process do |magick|
        magick.resize size
      end
    end

    def thumbnail
      process do |magick|
        magick.auto_orient
        magick.thumbnail "x#{thumbnail_size*2}"
        magick.resize "#{thumbnail_size*2}x<"
        magick.resize "50%"
        magick.gravity "center"
        magick.crop "#{thumbnail_size}x#{thumbnail_size}+0+0"
        magick.quality 92
      end
    end
  end
end
