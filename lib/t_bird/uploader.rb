# encoding: utf-8

module TBird
  class Uploader
    attr_reader :file, :acl, :options, :uploads, :content_type, :original_filename, :metadata
    def initialize(file, options = {})
      @file = file
      @acl = options.fetch(:acl, :public_read)
      @options = default_options.merge(options)
      @uploads = {}
      @content_type = @file[:type]
      @original_filename = @file[:filename]
      @metadata = { acl: acl, content_type: content_type, metadata: @options[:metadata] || {} }
    end

    def namer
      @namer ||= Namer.new(original_filename, options[:identifier], options[:token])
    end

    def processor
      Processor.new(@file[:tempfile])
    end

    def transmitter
      @transmitter ||= Transmitter.new
    end

    def upload!
      versions.each do |version,block|
        @uploads[version] = transmitter.transmit!(namer.new_name(version), block.call(processor), metadata)
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
        token: nil
      }
    end
  end
end
