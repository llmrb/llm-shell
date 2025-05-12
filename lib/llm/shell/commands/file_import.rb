# frozen_string_literal: true

class LLM::Shell::Command
  class FileImport
    ##
    # Completes a path with a wildcard.
    # @param path [String]
    #  The path to complete.
    # @return [Array<String>]
    #  Returns the completed path(s)
    def self.complete(path)
      Dir["#{path}*"]
    end

    ##
    # @param [LLM::Shell::Context] context
    #  The context of the command
    # @return [LLM::Shell::Command::FileImport]
    def initialize(context)
      @context = context
    end

    ##
    # Imports one or more globbed files.
    # @return [void]
    def call(*files)
      Dir[*files].each { import(_1) }
    end

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

  LLM.command "file-import" do |cmd|
    cmd.description "Share one or more files with the LLM"
    cmd.register(FileImport)
  end
end
