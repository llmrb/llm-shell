# frozen_string_literal: true

require "optparse"
require "readline"
require "llm"
require "io/line"
require "paint"

class LLM::Shell
  require_relative "shell/formatter"
  require_relative "shell/default"
  require_relative "shell/options"
  require_relative "shell/loop"

  def initialize(options)
    @options = Options.new(options)
    @default = Default.new(provider)
    @bot = LLM::Chat.new(llm).lazy
    @loop = Loop.new(@bot, default: @default, options: @options)
  end

  def start
    loop.setup
    loop.start
  end

  private

  attr_reader :options,
              :loop

  def provider = LLM.method(options.provider)
  def llm = provider.call(options.token, options.extra)
end
