# frozen_string_literal: true

class LLM::Shell
  ##
  # The {LLM::Shell::REPL LLM::Shell::REPL} class represents a loop
  # that accepts user input, evaluates it via the LLM, and prints the
  # response to stdout.
  class REPL
    ##
    # @param [LLM::Chat] bot
    # @param [LLM::Shell::Options] options
    # @return [LLM::Shell::REPL]
    def initialize(bot, options:)
      @bot = bot
      @console = IO.console
      @options = options
      @line = IO::Line.new($stdout)
    end

    ##
    # Performs initial setup
    # @return [void]
    def setup
      chat options.default.prompt, role: options.default.role
      files.each { bot.chat ["# START: #{_1}", File.read(_1), "# END: #{_1}"].join("\n") }
      bot.messages.each(&:read!)
      clear_screen
    end

    ##
    # Enters the main loop
    # @return [void]
    def start
      loop do
        read
        eval
        emit
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

    attr_reader :bot, :console,
                :line, :default,
                :options

    def formatter(messages) = Formatter.new(messages)
    def unread = bot.messages.unread
    def functions = bot.functions
    def files = @options.files
    def clear_screen = console.clear_screen

    def read
      input = Readline.readline("llm> ", true) || throw(:exit, 0)
      chat input.tap { clear_screen }
      line.rewind.print(Paint["Thinking", :bold])
      unread.tap { line.rewind }
    end

    def eval
      functions.each do |function|
        print Paint["system", :bold, :red], " says: ", "\n"
        print "function: " , function.name, "\n"        
        print "arguments: ", function.arguments, "\n"
        print "Do you want to call it? "
        input = $stdin.gets.chomp.downcase
        puts
        if %w(y yes yeah ok).include?(input)
          bot.chat function.call
          unread.tap { line.rewind }
        else
          print "Skipping function call", "\n"
        end
      end
    end

    def emit
      print formatter(unread).format!(:user), "\n"
      print formatter(unread).format!(:assistant), "\n"
    end

    def chat(...)
      case options.provider
      when :openai then bot.respond(...)
      else bot.chat(...)
      end
    end
  end
end
