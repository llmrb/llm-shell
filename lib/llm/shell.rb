# frozen_string_literal: true

require "optparse"
require "readline"
require "yaml"
require "llm"
require "paint"

class LLM::Shell
  require_relative "../io/line"
  require_relative "shell/markdown"
  require_relative "shell/formatter"
  require_relative "shell/default"
  require_relative "shell/options"
  require_relative "shell/repl"
  require_relative "shell/config"

  ##
  # @param [Hash] options
  # @return [LLM::Shell]
  def initialize(options)
    @config  = Config.new(options[:provider])
    @options = Options.new @config.merge(options), Default.new(options[:provider])
    @bot  = LLM::Chat.new(llm, @options.chat).lazy
    @repl = REPL.new(@bot, options: @options)
  end

  ##
  # Start the shell
  # @return [void]
  def start
    repl.setup
    repl.start
  end

  private

  attr_reader :options, :bot, :repl
  def provider = LLM.method(options.provider)
  def llm = provider.call(options.token, options.llm)
end
