# encoding: utf-8

module TBird
  class Upload
    attr_reader :options
    def initialize(file, options = {})
      @options = default_options.merge(options)
      @file = file
    end

    def content_type
      @file_data ||= @file.content_type
    end

    def original_filename
      @file_data ||= @file.original_filename
    end

    def original_file
      @file_data ||= @file.read
    end

    private

    def default_options
      {}
    end
  end
end
