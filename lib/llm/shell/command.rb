# frozen_string_literal: true

class LLM::Shell
  class Command
    Context = Struct.new(:bot, :io)

    ##
    # Set or get the command name
    # @param [String, nil] name
    #  The name of the command
    def name(name = nil)
      if name
        @name = name
      else
        @name
      end
    end

    ##
    # Setup the command context
    # @return [void]
    def setup(bot, io)
      @context = Context.new(bot, io)
    end

    ##
    # Define the command
    # @return [void]
    def define(klass = nil, &b)
      @runner = klass || b
    end
    alias_method :register, :define

    ##
    # Call the command
    # @reurn [void]
    def call(*argv)
      if @context.nil?
        raise "context has not been setup"
      elsif Class === @runner
        @runner.new(@context).call(*argv)
      else
        @context.instance_exec(*argv, &@runner)
      end
    end
  end
end
