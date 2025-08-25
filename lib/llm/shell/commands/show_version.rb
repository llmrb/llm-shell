# frozen_string_literal: true

class LLM::Shell::Command
  class ShowVersion
    require_relative "utils"
    include Utils

    ##
    # @param [LLM::Shell::Context] context
    #  The context of the command
    # @return [LLM::Shell::Command::ShowVersion]
    def initialize(context)
      @context = context
    end

    ##
    # Shows the current llm-shell version
    # @return [void]
    def call
      pager do |io|
        io.write("llm-shell version: #{LLM::Shell::VERSION}\n")
      end
    end

    private

    LLM.command "show-version" do |cmd|
      cmd.description "Show the llm-shell version"
      cmd.register(self)
      cmd.builtin!
    end
  end
end
