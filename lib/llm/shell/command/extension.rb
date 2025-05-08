# frozen_string_literal: true

class LLM::Shell::Command
  module Extension
    ##
    # @example
    #   LLM.command do |cmd|
    #     cmd.name "hello"
    #     cmd.define do |name|
    #       io.rewind.print("Hello #{name}")
    #     end
    #   end
    # @yieldparam [LLM::Shell::Command] cmd
    #  Yields an instance of LLM::Shell::Command
    # @return [void]
    def command
      cmd = LLM::Shell::Command.new
      yield cmd
      commands[cmd.name] = cmd
    end

    ##
    # @return [Hash<String, LLM::Shell::Command>]
    def commands
      @commands ||= {}
    end
  end
  LLM.extend(Extension)
end
