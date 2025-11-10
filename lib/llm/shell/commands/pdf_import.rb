# frozen_string_literal: true

class LLM::Shell
  class Command::PDFImport < Command
    name "pdf-import"
    description "Import a PDF"

    ##
    # Completes a path with a wildcard.
    # @param path [String]
    #  The path to complete.
    # @return [Array<String>]
    #  Returns the completed path(s)
    def self.complete(path)
      Dir["#{path}*.pdf"]
    end

    ##
    # Imports a PDF file.
    # @return [void]
    def call(pdf)
      bot.chat bot.local_file(pdf)
    end
  end
end
