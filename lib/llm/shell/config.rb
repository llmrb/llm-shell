# frozen_string_literal: true

class LLM::Shell
  class Config
    ##
    # @param [String] provider
    # @return [LLM::Shell::Config]
    def initialize(provider)
      @provider = provider
    end

    ##
    # @return [Hash]
    def merge(other)
      to_h.merge(other)
    end

    ##
    # @return [Hash]
    def to_h
      yaml[@provider] || {}
    end

    private

    def yaml
      return {} unless File.readable?(path)
      @yaml ||= YAML.load_file(path)
    end

    def path
      File.join Dir.home, ".llm-shell", "config.yml"
    end
  end
end
