# frozen_string_literal: true

class LLM::Shell
  class Command::DebugMode < Command
    name "debug-mode"
    description "Enter into debug mode"

    def call
      binding.irb
    end
  end
end
