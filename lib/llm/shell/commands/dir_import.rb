# frozen_string_literal: true

class LLM::Shell::Command
  class DirImport
    require_relative "mixin"
    include Mixin

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
    # @return [LLM::Shell::Command::DirImport]
    def initialize(context)
      @context = context
    end

    ##
    # Recursively imports all files in a directory.
    # @return [void]
    def call(dir)
      Dir.entries(dir).each do |file|
        if file == "." || file == ".."
          next
        elsif File.directory? File.join(dir, file)
          call File.join(dir, file)
        else
          import File.join(dir, file)
        end
      end
    end
  end

  LLM.command "dir-import" do |cmd|
    cmd.description "Share the contents of a directory with the LLM"
    cmd.register(DirImport)
  end
end
