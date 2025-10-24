# frozen_string_literal: true

class LLM::Shell
  class Command
    ##
    # @param [Class] klass
    #  A subclass
    # @return [void]
    def self.inherited(klass)
      LLM::Shell.commands << klass
    end

    ##
    # Set or get the command name
    # @param [String, nil] name
    #  The name of the command
    # @return [String]
    def self.name(name = nil)
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
    def self.description(desc = nil)
      if desc
        @description = desc
      else
        @description
      end
    end

    ##
    # @param [LLM::Bot] bot
    #  An instance of {LLM::Bot LLM::Bot}
    # @param [IO::Line] io
    #  An IO object
    def initialize(bot, io)
      @bot = bot
      @io = io
    end

    ##
    # Call the command
    # @reurn [void]
    def call(*argv)
      raise NotImplementedError
    end

    ##
    # @return [Boolean]
    #  Returns true if this is a builtin command
    def builtin?
      __FILE__.include?(LLM::Shell.root)
    end

    private

    attr_reader :bot, :io

    def import(file)
      return unless File.file?(file)
      bot.chat [
        "<file path=\"#{file}\">",
        File.read(file),
        "</file>"
      ].join("\n")
    end

    def file_pattern
      /\A<file path=(.+?)>/
    end

    def pager(...)
      LLM::Shell.pager(...)
    end
  end
end
