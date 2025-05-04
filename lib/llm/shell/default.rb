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
      "Do not provide long answers."
    end

    def role
      :system
    end
  end
end
