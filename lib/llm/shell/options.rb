# frozen_string_literal: true

class LLM::Shell
  ##
  # The {LLM::Shell::Options LLM::Shell::Options} class represents
  # the options provided to the shell at the command line, and the
  # configuration file (if any). The command-line options take precedence
  # over the configuration file.
  class Options
    ##
    # @param [Hash] options
    # @param [LLM::Shell::Default] default
    # @return [LLM::Shell::Options]
    def initialize(options, default)
      @options  = options.transform_keys(&:to_sym)
      @provider = @options.delete(:provider)
      @tools    = @options.delete(:tools)
      @prompt   = @options[:prompt] ? custom_prompt : default.prompt
      @files    = Dir[*@options.delete(:files) || []].reject { File.directory?(_1) }
      @bot_options = {model: @options.delete(:model)}.compact
      @default  = default
    end

    def provider = @provider
    def tools = @tools
    def files = @files
    def llm = @options
    def bot = @bot_options
    def default = @default
    def prompt = File.read(@prompt)

    private

    def custom_prompt
      prompt = @options.delete(:prompt)
      File.join(LLM::Shell.home_data, "prompts", prompt)
    end
  end
end
