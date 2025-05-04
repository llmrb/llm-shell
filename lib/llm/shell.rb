# frozen_string_literal: true

module LLM
end unless defined?(LLM)

class LLM::Message
  def user?
    role == "user"
  end
end

class LLM::Shell
  require "optparse"
  require "readline"
  require "llm"
  require "io/line"
  require "paint"

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
    setup
    repl
  end

  private

  def setup
    bot.chat default_prompt, default_role
    files.each { bot.chat File.read(_1) }
    bot.messages.each(&:read!)
    console.clear_screen
  end

  def repl
    loop do
      input = Readline.readline("llm> ", true) || throw(:exit, 0)
      bot.chat(input)
      console.clear_screen
      line.rewind.print Paint["Thinking", :bold]
      emit(bot.messages.unread.select(&:user?), rewind: true, color: :yellow, padding: 2)
      emit(bot.messages.unread.select(&:assistant?), rewind: false, color: :green)
    rescue LLM::Error::ResponseError => ex
      print Paint[ex.response.class, :red], ":", "\n"
      print ex.response.body, "\n"
    rescue
      print Paint[ex.response, :red], ":", "\n"
      print ex.message, "\n"
    rescue Interrupt
      throw(:exit, 0)
    end
  end

  def emit(messages, rewind: false, color: :yellow, padding: 1)
    messages.each do |message|
      line.rewind if rewind
      print Paint[message.role, :bold, color], " says: ", "\n"
      print wrap(message.content), "\n" * padding
      message.read!
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

  def wrap(text, width = 80)
    c = 0
    words = text.split(/ /)
    words.each_with_object(StringIO.new) do |word, io|
      c += word.length
      if word.empty?
        io << "\n"
        c = 0
      elsif c >= width
        io << "\n" << word << " "
        c = 0
      else
        io << word << " "
      end
    end.string
  end

  def llm = LLM.method(@provider).call(token, **options)
  def bot = @bot
  def provider = @provider
  def token = @token
  def files = @files
  def options = @options
  def console = console
  def line = @line
end
