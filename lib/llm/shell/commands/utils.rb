# frozen_string_literal: true

class LLM::Shell::Command
  module Utils
    private

    def import(file)
      return unless File.file?(file)
      bot.chat [
        "<file path=\"#{file}\">",
        File.read(file),
        "</file>"
      ].join("\n")
    end

    def bot = @context.bot
    def io = @context.io
    def pager(...) = @context.pager(...)
    def file_pattern = /\A<file path=(.+?)>/
  end
end
