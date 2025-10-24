# frozen_string_literal: true

class LLM::Shell
  class Command::SystemPrompt < Command
    name "system-prompt"
    description "Show the system prompt"

    ##
    # Emits the system prompt to standard output
    # @return [void]
    def call
      pager do |io|
        io.write render(bot.messages[0])
      end
    end

    private

    def render(message) = LLM::Shell::Renderer.new(message).render
  end
end
