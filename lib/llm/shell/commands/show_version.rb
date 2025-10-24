# frozen_string_literal: true

class LLM::Shell
  class Command::ShowVersion < Command
    name "show-version"
    description "Show the version"

    ##
    # Shows the current llm-shell version
    # @return [void]
    def call
      pager do |io|
        io.write("llm-shell version: #{LLM::Shell::VERSION}\n")
      end
    end
  end
end
