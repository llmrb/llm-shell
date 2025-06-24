# frozen_string_literal: true

class LLM::Shell
  class Default
    def initialize(provider)
      @provider = provider
    end

    def prompt
      File.join(SHAREDIR, "prompts", "default.txt")
    end

    def role
      case @provider
      when "openai", "ollama" then :system
      else :user
      end
    end

    SHAREDIR = File.join(__dir__, "..", "..", "..", "share", "llm-shell")
    private_constant :SHAREDIR
  end
end
