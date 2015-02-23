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
    # @param scss_or_filename [String]
    def initialize(str_or_filename, syntax=:scss)
      if File.exist?(str_or_filename)
        build_from_file(str_or_filename)
      else
        build_from_string(str_or_filename, syntax)
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
    def build_from_file(path)
      @filename = path
      @engine = Sass::Engine.for_file(path, ENGINE_OPTIONS)
      @contents = File.open(path, 'r').read
    end

    # @param scss [String]
    def build_from_string(str, syntax)
      @engine = Sass::Engine.new(str, ENGINE_OPTIONS.merge(syntax: syntax))
      @contents = str
    end
  end
end
