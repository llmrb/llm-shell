# frozen_string_literal: true

class LLM::Shell
  class Command::FileImport < Command
    name "file-import"
    description "Import a file"

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
    # Imports one or more globbed files.
    # @return [void]
    def call(*files)
      Dir[*files].each { import(_1) }
    end
  end
end
