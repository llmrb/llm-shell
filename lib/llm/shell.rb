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
  require_relative "shell/loop"
  require_relative "shell/config"

  def initialize(options)
    @config  = Config.new(options[:provider])
    @default = Default.new(options[:provider])
    @options = Options.new @config.merge(options)
    @bot  = LLM::Chat.new(llm, @options.chat).lazy
    @loop = Loop.new(@bot, options: @options)
  end

  def start
    bot.chat default.prompt, default.role
    loop.setup
    loop.start
  end

  private

  attr_reader :default, :options, :bot, :loop
  def provider = LLM.method(options.provider)
  def llm = provider.call(options.token, options.llm)
end
