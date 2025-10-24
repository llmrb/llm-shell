# frozen_string_literal: true

module LLM
  $:.concat Dir[File.join(__dir__, "shell", "internal", "*", "lib")]
  require "optparse"
  require "io/line"
  require "paint"
  require "reline"
  require "coderay"
  require "llm"
end

class LLM::Shell
  require "yaml"
  require_relative "function"
  require_relative "shell/command"
  require_relative "shell/command/extension"
  require_relative "shell/markdown"
  require_relative "shell/renderer"
  require_relative "shell/formatter"
  require_relative "shell/default"
  require_relative "shell/options"
  require_relative "shell/repl"
  require_relative "shell/config"
  require_relative "shell/completion"
  require_relative "shell/version"

  ##
  # Load all commands
  Dir[File.join(__dir__, "shell", "commands", "*.rb")].each { require(_1) }

  ##
  # Opens a pager
  # @return [void]
  def self.pager(...)
    IO.popen("less -FRX", "w", ...)
  end

  ##
  # Returns the lib/ directory
  # @return [String]
  def self.root
    __dir__
  end

  ##
  # Returns ${HOME}/.llm-shell directory
  # @return [String]
  def self.home
    File.join Dir.home, ".llm-shell"
  end

  ##
  # @return [Array<String>]
  def self.tools
    Dir[*TOOLGLOBS]
  end

  ##
  # @return [Array<String>]
  def self.commands
    Dir[File.join(home, "commands", "*.rb")]
  end

  TOOLGLOBS = [
    File.join(home, "tools", "*.rb"),
    File.join(__dir__, "shell", "tools", "*.rb")
  ].freeze
  private_constant :TOOLGLOBS

  ##
  # @param [Hash] options
  # @return [LLM::Shell]
  def initialize(options)
    @config  = Config.new(options[:provider])
    @options = Options.new @config.merge(options), Default.new(options[:provider])
    @bot  = LLM::Bot.new(llm, {tools:}.merge(@options.bot))
    @repl = REPL.new(bot: @bot, options: @options)
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
    end
  end

  attr_reader :options, :bot, :repl
  def provider = LLM.method(options.provider)
  def llm = provider.call(**options.llm)
end
