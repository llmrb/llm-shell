# frozen_string_literal: true

require "optparse"
require "readline"
require "llm"
require "io/line"
require "paint"

class LLM::Shell
  require_relative "shell/formatter"

  def initialize(options)
    @provider = options.delete(:provider)
    @token = options.delete(:token)
    @files = Dir[*options.delete(:files) || []].reject { File.directory?(_1) }
    @options = options
    @bot = LLM::Chat.new(llm).lazy
    @console = IO.console
    @line = IO::Line.new($stdout)
  end

  def start
    setup_bot
    start_loop
  end

  private

  def setup_bot
    bot.chat default_prompt, default_role
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

  def default_role
    :system
  end

  def default_prompt
    "You are a helpful assistant." \
    "Answer the user's questions as best as you can." \
    "The user's environment is a terminal." \
    "Provide short and concise answers that are suitable for a terminal." \
    "Do not provide long answers."
  end

  def formatter(messages) = Formatter.new(messages)
  def llm = LLM.method(@provider).call(token, **options)
  def bot = @bot
  def unread = @bot.messages.unread
  def provider = @provider
  def token = @token
  def files = @files
  def options = @options
  def console = @console
  def line = @line
end
