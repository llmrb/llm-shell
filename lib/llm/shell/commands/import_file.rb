# frozen_string_literal: true

class LLM::Shell::Command
  class ImportFile
    def initialize(context)
      @context = context
    end

    def call(*files)
      Dir[*files].each { import(_1) }
    end

    private

    def import(file)
      bot.chat [
        "--- START: #{file} ---",
        File.read(file),
        "--- END: #{file} ---"
      ].join("\n")
    end

    def bot = @context.bot
    def io = @context.io
  end

  LLM.command do |command|
    command.name "import-file"
    command.register ImportFile
  end
end
