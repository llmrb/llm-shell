# frozen_string_literal: true

require "optparse"
require "readline"
require "yaml"
require "llm"
require "paint"

class LLM::Shell
  require_relative "../io/line"
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
  # @return [Array<String>]
  def self.commands
    Dir[File.join(home, "commands", "*.rb")]
  end

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
    LLM::Shell.tools.filter_map do |path|
      name = File.basename(path, File.extname(path))
      if options.tools.include?(name)
        print Paint["llm-shell: ", :green], "load #{name} tool", "\n"
        eval File.read(path), TOPLEVEL_BINDING, path, 1
      else
        print Paint["llm-shell: ", :yellow], "skip #{name} tool", "\n"
      end
    end.grep(LLM::Function)
  end

  attr_reader :options, :bot, :repl
  def provider = LLM.method(options.provider)
  def llm = provider.call(**options.llm)
end
