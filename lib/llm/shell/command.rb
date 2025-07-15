# frozen_string_literal: true

class LLM::Shell
  class Command
    require_relative "commands/utils"
    Context = Struct.new(:bot, :io)

    ##
    # Returns the underlying command object
    # @return [Class, #call]
    attr_reader :object

    ##
    # Set or get the command name
    # @param [String, nil] name
    #  The name of the command
    # @return [String]
    def name(name = nil)
      if name
        @name = name
      else
        @name
      end
    end

    ##
    # Set or get the command description
    # @param [String, nil] desc
    #  The description of the command
    # @return [String]
    def description(desc = nil)
      if desc
        @description = desc
      else
        @description
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
      @object = klass || b
    end
    alias_method :register, :define

    ##
    # Call the command
    # @reurn [void]
    def call(*argv)
      if @context.nil?
        raise "context has not been setup"
      elsif Class === @object
        @object.new(@context).call(*argv)
      else
        @context.instance_exec(*argv, &@object)
      end
    end
  end
end
