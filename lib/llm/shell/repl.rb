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
      Reline.completion_proc = Completion.to_proc
      chat(options.prompt, role: options.default.role).flush
      unread.each(&:read!)
      clear_screen
    end

    ##
    # Enters the main loop
    # @return [void]
    def start
      loop do
        catch(:next) do
          read
          eval while functions.any?
          emit
        end
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
      input = Reline.readline("llm> ", true) || throw(:exit, 0)
      words = input.split(" ")
      if cmd = LLM::Shell.find_command(words[0])
        argv = words[1..]
        cmd.new(bot, io).call(*argv)
        throw(:next)
      else
        chat input.tap { clear_screen }
        io.rewind.print(Paint["Thinking", :bold])
        unread.tap { io.rewind }
      end
    end

    def eval
      callables = []
      cancels = []
      results = []
      functions.each do |function|
        args = function.arguments.to_json
        print Paint["system", :bold, :red], " says: ", "\n"
        print "function ".ljust(20), function.name, "\n"
        print "arguments ".ljust(20), ((args.size >= 80) ? "#{args[0..79]} ...}" : args), "\n"
        print "argument count".ljust(20), function.arguments.to_h.size, "\n\n"
        input = Reline.readline("Should we proceed? ", true)
        puts
        if %w(y yes yep yeah ok).include?(input)
          callables << function
        else
          cancels << function
        end
      end
      results.concat callables.map(&:call)
      results.concat cancels.map(&:cancel)
      bot.chat(results)
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
    def clear_screen = console.clear_screen
    def chat(...) = bot.chat(...)
  end
end
