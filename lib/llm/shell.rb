# frozen_string_literal: true

require "optparse"
require "readline"
require "llm"
require "io/line"
require "paint"

class LLM::Shell
  require_relative "shell/formatter"
  require_relative "shell/default"

  def initialize(options)
    @provider = options.delete(:provider)
    @token = options.delete(:token)
    @files = Dir[*options.delete(:files) || []].reject { File.directory?(_1) }
    @options = options
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
              :token,
              :files,
              :options,
              :console,
              :default,
              :line

  def formatter(messages) = Formatter.new(messages)
  def unread = @bot.messages.unread
  def provider = LLM.method(@provider)
  def llm = provider.call(token, **options)

  def setup_bot
    bot.chat default.prompt, default.role
    files.each { bot.chat File.read(_1) }
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
