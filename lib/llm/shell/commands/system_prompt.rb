# frozen_string_literal: true

class LLM::Shell::Command
  class SystemPrompt
    require_relative "utils"
    include Utils

    ##
    # @param [LLM::Shell::Context] context
    #  The context of the command
    # @return [LLM::Shell::Command::SystemPrompt]
    def initialize(context)
      @context = context
    end

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

    LLM.command "system-prompt" do |cmd|
      cmd.description "Show the system prompt"
      cmd.register(self)
      cmd.builtin!
    end
  end
end
