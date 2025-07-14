# frozen_string_literal: true

class LLM::Shell::Command
  class ShowHistory
    require_relative "utils"
    include Utils

    ##
    # @param [LLM::Shell::Context] context
    #  The context of the command
    # @return [LLM::Shell::Command::ShowHistory]
    def initialize(context)
      @context = context
    end

    ##
    # Emits the full chat history to standard output
    # @return [void]
    def call
      clear_screen
      emit
    end

    private

    def emit
      IO.popen("less -FRX", "w") do |io|
        messages.each.with_index do |message, index|
          next if index <= 1
          io << render(message) << "\n"
        end
      end
    end

    def console = IO.console
    def clear_screen = console.clear_screen
    def messages = bot.messages
    def render(message) = LLM::Shell::Renderer.new(message).render

    LLM.command "show-history" do |cmd|
      cmd.description "Show the full chat history"
      cmd.register(self)
    end
  end
end
