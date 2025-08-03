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
    def initialize(bot:, options:)
      @bot = bot
      @console = IO.console
      @options = options
      @io = IO::Line.new($stdout)
    end

    ##
    # Performs initial setup
    # @return [void]
    def setup
      LLM::Shell.commands.each { |file| require file }
      Readline.completion_proc = Completion.to_proc
      chat options.prompt, role: options.default.role
      files.each { chat ["--- START: #{_1} ---", File.read(_1), "--- END: #{_1} ---"].join("\n") }
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
      rescue LLM::ResponseError => ex
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

    def read
      input = Readline.readline("llm> ", true) || throw(:exit, 0)
      words = input.split(" ")
      if LLM.commands[words[0]]
        cmd  = LLM.commands[words[0]]
        argv = words[1..]
        cmd.setup(bot, io)
        cmd.call(*argv)
      else
        chat input.tap { clear_screen }
        io.rewind.print(Paint["Thinking", :bold])
        unread.tap { io.rewind }
      end
    end

    def eval
      functions.each do |function|
        print Paint["system", :bold, :red], " says: ", "\n"
        print "function: ", function.name, "\n"
        print "arguments: ", function.arguments, "\n"
        print "Do you want to call it? "
        input = $stdin.gets.chomp.downcase
        puts
        if %w(y yes yep yeah ok).include?(input)
          chat function.call
          unread.tap { io.rewind }
        else
          chat function.cancel
          chat "I decided to not run the function this time. Maybe next time."
        end
      end
    end

    def emit
      LLM::Shell.pager do |io|
        io.write formatter(unread).format!(:user), "\n"
        io.write formatter(unread).format!(:assistant), "\n"
      end unless unread.empty?
    end

    attr_reader :bot, :console, :io, :default, :options

    def formatter(messages) = Formatter.new(messages)
    def unread = bot.messages.unread
    def functions = bot.functions
    def files = @options.files
    def clear_screen = console.clear_screen
    def chat(...) = bot.chat(...)
  end
end
