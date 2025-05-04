# frozen_string_literal: true

class LLM::Shell
  class Default
    def initialize(provider)
      @provider = provider
    end

    def prompt
      "You are a helpful assistant." \
      "Answer the user's questions as best as you can." \
      "The user's environment is a terminal." \
      "Provide short and concise answers that are suitable for a terminal." \
      "Do not provide long answers." \
      "One or more files might be provided at the start of the conversation. " \
      "The user might ask you about them, you should try to understand them and what they are. " \
      "If you don't understand something, say so. " \
      "Each file will be surrounded by the following markers: " \
      "'# START: /path/to/file'" \
      "'# END: /path/to/file'"
    end

    def role
      case @provider
      when "openai", "ollama" then :system
      else :user
      end
    end
  end
end
