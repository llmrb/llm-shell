# frozen_string_literal: true

class LLM::Shell::Command
  module Utils
    private

    def import(file)
      return unless File.file?(file)
      bot.chat [
        "--- START: #{file} ---",
        File.read(file),
        "--- END: #{file} ---"
      ].join("\n")
    end

    def bot = @context.bot
    def io = @context.io
  end
end
