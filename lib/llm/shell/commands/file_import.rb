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
    def call(*globs)
      files = Dir[*globs]
      prompt = bot.build_prompt do |prompt|
        files.each { |file| visit(file, prompt) }
      end
      bot.chat(prompt)
    end

    private

    def visit(file, prompt)
      exts = %w[.pdf .png .jpg .jpeg]
      if exts.include?(File.extname(file))
        prompt.user bot.local_file(file)
      else
        prompt.user read(file)
      end
    end
  end
end
