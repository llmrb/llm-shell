# frozen_string_literal: true

class LLM::Shell
  class Command::ShowChat < Command
    name "show-chat"
    description "Show the chat"

    ##
    # Emits the full chat history to standard output
    # @return [void]
    def call
      clear_screen
      emit
    end

    private

    def emit
      pager do |io|
        messages.each.with_index do |message, index|
          io << render(message) << "\n"
        end
      end
    end

    def console = IO.console
    def clear_screen = console.clear_screen
    def messages = bot.messages
    def render(message) = LLM::Shell::Renderer.new(message).render
  end
end
