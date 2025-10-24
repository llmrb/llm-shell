# frozen_string_literal: true

class LLM::Shell
  class Completion
    ##
    # Returns a proc suitable for Reline completion.
    # @return [Proc]
    def self.to_proc
      new.to_proc
    end

    ##
    # @return [LLM::Shell::Completion]
    def initialize
      @commands = LLM.commands
    end

    ##
    # Returns a proc suitable for Reline completion.
    # @return [Proc]
    def to_proc
      method(:complete).to_proc
    end

    private

    def complete(input)
      words = Reline.line_buffer.split(" ")
      command = words[0]
      if commands[command]
        object = commands[command].object
        object.respond_to?(:complete) ? object.complete(input) : []
      else
        commands.keys.grep(/\A#{command}/)
      end
    end

    attr_reader :commands
  end
end
