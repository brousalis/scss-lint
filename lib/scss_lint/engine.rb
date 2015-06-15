require 'sass'

module SCSSLint
  class FileEncodingError < StandardError; end

  # Contains all information for a parsed SCSS file, including its name,
  # contents, and parse tree.
  class Engine
    ENGINE_OPTIONS = { cache: false, syntax: :scss }

    attr_reader :contents, :filename, :lines, :tree

    # Creates a parsed representation of an SCSS document from the given string
    # or file.
    #
    # @param options [Hash]
    # @option options [String] :file The file to load
    # @option options [String] :code The code to parse
    # @param [String] :syntax The syntax type to parse
    def initialize(options = {}, syntax=:scss)
      if options[:file]
        build_from_file(options[:file], syntax)
      elsif options[:code]

        build_from_string(options[:code], syntax)
      end

      # Need to force encoding to avoid Windows-related bugs.
      # Need `to_a` for Ruby 1.9.3.
      @lines = @contents.force_encoding('UTF-8').lines.to_a
      @tree = @engine.to_tree
    rescue Encoding::UndefinedConversionError, Sass::SyntaxError => error
      if error.is_a?(Encoding::UndefinedConversionError) ||
         error.message.match(/invalid.*(byte sequence|character)/i)
        raise FileEncodingError,
              "Unable to parse SCSS file: #{error}",
              error.backtrace
      else
        raise
      end
    end

  private

    # @param path [String]
    # TODO: parse file extension switch sass syntax option
    def build_from_file(path, syntax)
      @filename = path
      @engine = Sass::Engine.for_file(path, ENGINE_OPTIONS.merge(syntax: syntax))
      @contents = File.open(path, 'r').read
    end

    # @param scss [String]
    def build_from_string(str, syntax)
      @engine = Sass::Engine.new(str, ENGINE_OPTIONS.merge(syntax: syntax))
      @contents = str
    end
  end
end
