# frozen_string_literal: true

class LLM::Shell
  class Formatter
    FormatError = Class.new(RuntimeError)

    def initialize(messages)
      @messages = messages
    end

    def format!(role)
      case role
      when :user then format_user(messages)
      when :assistant then format_assistant(messages)
      else raise FormatError.new("#{role} is not known")
      end
    end

    private

    attr_reader :messages

    def format_user(messages)
      messages.flat_map do |message|
        next unless message.user?
        role  = Paint[message.role, :bold, :yellow]
        title = "#{role} says: "
        body  = wrap(message.tap(&:read!).content)
        [title, body, ""].join("\n")
      end.join
    end

    def format_assistant(messages)
      messages.flat_map do |message|
        next unless message.assistant?
        role  = Paint[message.role, :bold, :green]
        title = "#{role} says: "
        body  = wrap(message.tap(&:read!).content)
        [title, body].join("\n")
      end.join
    end

    def wrap(text, width = 80)
      text.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
    end
  end
end
