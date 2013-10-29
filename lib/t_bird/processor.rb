# encoding: utf-8

require 'mini_magick'

module TBird
  class Processor
    attr_reader :image
    def initialize(file_blob)
      @image = MiniMagick::Image.read(file_blob)
      @tempfile = Tempfile.new(SecureRandom.uuid)
    end

    def process(&block)
      image.combine_options do |img|
        block.call(img) if block_given?
      end
      write_to_file
    end

    def write_to_file
      image.write @tempfile
      @tempfile
    end
    
    def original
      write_to_file
    end

    def resize(size)
      process do |img|
        img.resize size
      end
    end

    def thumbnail(thumbnail_size = Configuration.thumbnail_size)
      process do |img|
        img.auto_orient
        img.thumbnail "x#{thumbnail_size*2}"
        img.resize "#{thumbnail_size*2}x<"
        img.resize "50%"
        img.gravity "center"
        img.crop "#{thumbnail_size}x#{thumbnail_size}+0+0"
        img.quality 92
      end
    end
  end
end
