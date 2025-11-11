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
      files = Dir.entries(dir)
      prompt = bot.build_prompt do |prompt|
        files.each { |file| visit(dir, file, prompt) }
      end
      bot.chat(prompt)
    end

    ##
    # Visit a file with a prompt
    # @return [void]
    def visit(dir, file, prompt)
      if file == "." || file == ".."
        nil
      elsif File.directory? File.join(dir, file)
        call File.join(dir, file)
      else
        prompt.user read(File.join(dir, file))
      end
    end
  end
end
