# frozen_string_literal: true

class LLM::Shell
  class Loop
    def initialize(bot, options:, default:)
      @bot = bot
      @console = IO.console
      @options = options
      @default = default
      @line = IO::Line.new($stdout)
    end

    def setup
      bot.chat default.prompt, default.role
      files.each { bot.chat File.read(_1) }
      bot.messages.each(&:read!)
      console.clear_screen
    end

    def start
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

    private

    attr_reader :bot,
                :console,
                :line,
                :default,
                :options

    def formatter(messages) = Formatter.new(messages)
    def unread = bot.messages.unread
    def files = @options.files
  end
end
