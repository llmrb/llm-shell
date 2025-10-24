# frozen_string_literal: true

class LLM::Shell
  class Command::DirImport < Command
    name "dir-import"
    description "Import the contents of a directory"

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
end
