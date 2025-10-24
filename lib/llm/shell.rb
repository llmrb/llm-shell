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
  # @return [Array<LLM::Command>]
  def self.commands
    @commands ||= []
  end

  ##
  # @return [Array<LLM::Tool>]
  def self.tools
    @tools ||= []
  end

  ##
  # Returns an instance of {LLM::Command LLM::Command}, or nil.
  # @return [LLM::Command, nil]
  def self.find_command(name)
    commands.find { _1.name == name }
  end

  require "yaml"
  require_relative "shell/tool"
  require_relative "shell/command"
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
  # Load commands & tools
  Dir[File.join(__dir__, "shell", "commands", "*.rb")].each { require(_1) }
  Dir[File.join(__dir__, "shell", "tools", "*.rb")].each { require(_1) }
  Dir[File.join(home, "tools", "*.rb")].each { require(_1) }

  ##
  # @param [Hash] options
  # @return [LLM::Shell]
  def initialize(options)
    @config  = Config.new(options[:provider])
    @options = Options.new @config.merge(options), Default.new(options[:provider])
    @bot  = LLM::Bot.new(llm, {tools: LLM::Shell.tools}.merge(@options.bot))
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

  attr_reader :options, :bot, :repl
  def provider = LLM.method(options.provider)
  def llm = provider.call(**options.llm)
end
