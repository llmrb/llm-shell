# frozen_string_literal: true

class LLM::Shell
  class Formatter
    FormatError = Class.new(RuntimeError)
    FILE_REGEXP = /\A--- START: (.+?) ---/

    def initialize(messages)
      @messages = messages.reject(&:tool_call?)
    end

    def format!(role)
      case role
      when :user then format_user(messages)
      when :assistant then format_assistant(messages)
      else raise FormatError.new("#{role} is not known")
      end
    end

    private

    def format_user(messages)
      messages.filter_map do |message|
        next unless message.user?
        next unless String === message.content
        next unless message.content !~ FILE_REGEXP
        render(message.tap(&:read!))
      end.join("\n")
    end

    def format_assistant(messages)
      messages.filter_map do |message|
        next unless message.assistant?
        next unless String === message.content
        render(message.tap(&:read!))
      end.join("\n")
    end

    attr_reader :messages
    def render(message) = Renderer.new(message).render
  end
end
