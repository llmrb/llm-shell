# frozen_string_literal: true

module LLM
  $:.unshift(*Dir[File.join(__dir__, "shell", "internal", "*", "lib")])
  require "optparse"
  require "io/line"
  require "paint"
  require "reline"
  require "coderay"
  require "llm"
  require "tomlrb"
end

class LLM::Shell
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
  # Returns the lib/ directory
  # @return [String]
  def self.root
    __dir__
  end

  ##
  # Returns the directory where configuration files are kept
  # @return [String]
  def self.home_config
    if ENV.key?("XDG_CONFIG_HOME")
      ENV["XDG_CONFIG_HOME"]
    else
      File.join Dir.home, ".config"
    end
  end

  ##
  # Returns the directory where commands and tools are kept
  # @return [String]
  def self.home_data
    if ENV.key?("XDG_DATA_HOME")
      File.join ENV["XDG_DATA_HOME"], "llm-shell"
    else
      File.join Dir.home, ".local", "share", "llm-shell"
    end
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

  ##
  # @return [Regexp]
  def self.pattern
    /\A<file path=(.+?)>/
  end

  ##
  # Opens a pager
  # @return [void]
  def self.pager(...)
    IO.popen("less -FRX", "w", ...)
  end

  ##
  # Load commands & tools
  Dir[File.join(home_data, "commands", "*.rb")].each { require(_1) }
  Dir[File.join(home_data, "tools", "*.rb")].each { require(_1) }
  Dir[File.join(root, "shell", "commands", "*.rb")].each { require(_1) }
  Dir[File.join(root, "shell", "tools", "*.rb")].each { require(_1) }

  ##
  # @param [Hash] opts
  # @return [LLM::Shell]
  def initialize(opts)
    @config  = Config.new(opts[:provider])
    @options = Options.new @config.merge(opts), Default.new(opts[:provider])
    @bot  = LLM::Bot.new(llm, options.bot)
    @repl = REPL.new(bot:, options:)
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

  ##
  # @return [Method]
  def provider
    LLM.method(options.provider)
  end

  ##
  # @return [LLM::Provider]
  def llm
    provider.call(**options.llm)
  end
end

module LLM
  Command = LLM::Shell::Command
end
