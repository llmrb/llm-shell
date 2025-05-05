# frozen_string_literal: true

class LLM::Shell
  class Options
    def initialize(options)
      @options  = options.transform_keys(&:to_sym)
      @provider = @options.delete(:provider)
      @token    = @options.delete(:token)
      @files    = Dir[*@options.delete(:files) || []].reject { File.directory?(_1) }
      @chat_options = {model: @options.delete(:model)}.compact
    end

    def provider = @provider
    def token = @token
    def files = @files
    def llm = @options
    def chat = @chat_options
  end
end
