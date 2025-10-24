# frozen_string_literal: true

class LLM::Shell
  class Command::ClearScreen < Command
    name "clear-screen"
    description "Clears the screen"

    ##
    # Clears the screen
    # @return [void]
    def call = clear_screen

    private

    def console = IO.console
    def clear_screen = console.clear_screen
  end
end
