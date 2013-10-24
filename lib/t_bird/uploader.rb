# encoding: utf-8

module TBird
  class Uploader
    attr_reader :file, :options, :uploads, :content_type, :original_filename
    def initialize(file, options = {})
      @file = file
      @options = default_options.merge(options)
      @uploads = {}
      @content_type = @file.content_type
      @original_filename = @file.original_filename
      @options[:metadata].merge!(content_type: content_type)
    end

    def namer
      @namer ||= Namer.new(original_filename, options[:identifier], options[:token])
    end

    def processor
      @processor ||= Processor.new(@file)
    end

    def upload!
      versions.each do |version,block|
        block.call(processor)
        transmission = Transmitter.new(namer.new_name(version), processor.stream, options[:metadata])
        transmission.transmit!
        @uploads[version] = transmission.url
      end
      uploads
    end

    def versions
      self.class.versions
    end

    def self.versions
      @versions ||= { 
        thumbnail: ->(img) { img.thumbnail },
        original: ->(img) { img.original }
      }
    end 

    def self.version(name, &block)
      @versions ||= {}
      @versions[name.to_sym] = block
    end

    private

    def default_options
      {
        identifier: nil,
        token: nil,
        metadata: {}
      }
    end
  end
end
