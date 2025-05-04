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

  def initialize(options)
    @options = Options.new(options)
    @bot = LLM::Chat.new(llm).lazy
    @console = IO.console
    @line = IO::Line.new($stdout)
    @default = Default.new(provider)
  end

  def start
    setup_bot
    start_loop
  end

  private

  attr_reader :bot,
              :options,
              :console,
              :default,
              :line

  def formatter(messages) = Formatter.new(messages)
  def unread = @bot.messages.unread
  def provider = LLM.method(options.provider)
  def llm = provider.call(options.token, options.extra)

  def setup_bot
    bot.chat default.prompt, default.role
    options.files.each { bot.chat File.read(_1) }
    bot.messages.each(&:read!)
    console.clear_screen
  end

  def start_loop
    loop do
      input = Readline.readline("llm> ", true) || throw(:exit, 0)
      bot.chat(input)
      console.clear_screen
      line.rewind.print(Paint["Thinking", :bold])
      [messages = unread, line.rewind]
      print formatter(messages).format!(:user)
      print formatter(messages).format!(:assistant)
    rescue LLM::Error::ResponseError => ex
      print Paint[ex.response.class, :red], "\n"
      print ex.response.body, "\n"
    rescue => ex
      print Paint[ex.class, :red], "\n"
      print ex.message, "\n"
      print ex.backtrace[0..5].join("\n")
    rescue Interrupt
      throw(:exit, 0)
    end
  end
end
