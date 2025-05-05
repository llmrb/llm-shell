# frozen_string_literal: true

require "optparse"
require "readline"
require "yaml"
require "llm"
require "io/line"
require "paint"

class LLM::Shell
  require_relative "shell/formatter"
  require_relative "shell/default"
  require_relative "shell/options"
  require_relative "shell/repl"
  require_relative "shell/config"

  def initialize(options)
    @config  = Config.new(options[:provider])
    @default = Default.new(options[:provider])
    @options = Options.new @config.merge(options)
    @bot  = LLM::Chat.new(llm, @options.chat).lazy
    @repl = REPL.new(@bot, options: @options)
  end

  def start
    bot.chat default.prompt, default.role
    repl.setup
    repl.start
  end

  private

  attr_reader :default, :options, :bot, :repl
  def provider = LLM.method(options.provider)
  def llm = provider.call(options.token, options.llm)
end
