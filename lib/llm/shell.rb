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
  # @return [String]
  def self.home
    File.join Dir.home, ".llm-shell"
  end

  ##
  # @return [Array<String>]
  def self.tools
    Dir[File.join(home, "tools", "*.rb")]
  end

  ##
  # @param [Hash] options
  # @return [LLM::Shell]
  def initialize(options)
    @config  = Config.new(options[:provider])
    @options = Options.new @config.merge(options), Default.new(options[:provider])
    @bot  = LLM::Chat.new(llm, {tools:}.merge(@options.chat)).lazy
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

  def tools
    LLM::Shell.tools.map do |path|
      eval File.read(path), TOPLEVEL_BINDING, path, 1
    end.grep(LLM::Function)
  end

  attr_reader :options, :bot, :repl
  def provider = LLM.method(options.provider)
  def llm = provider.call(options.token, options.llm)
end
