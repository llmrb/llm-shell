# frozen_string_literal: true

class LLM::Shell
  class Options
    def initialize(options)
      @options = options
      @provider = options.delete(:provider)
      @token = options.delete(:token)
      @files = Dir[*options.delete(:files) || []].reject { File.directory?(_1) }
    end

    def provider = @provider
    def token = @token
    def files = @files
    def extra = @options
  end
end
