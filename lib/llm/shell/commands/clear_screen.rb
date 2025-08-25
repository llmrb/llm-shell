# frozen_string_literal: true

class LLM::Shell::Command
  class ClearScreen
    require_relative "utils"
    include Utils

    ##
    # @param [LLM::Shell::Context] context
    #  The context of the command
    # @return [LLM::Shell::Command::ClearScreen]
    def initialize(context)
      @context = context
    end

    ##
    # Clears the screen
    # @return [void]
    def call = clear_screen

    private

    def console = IO.console
    def clear_screen = console.clear_screen

    LLM.command "clear-screen" do |cmd|
      cmd.description "Clear the screen"
      cmd.register(self)
      cmd.builtin!
    end
  end
end
