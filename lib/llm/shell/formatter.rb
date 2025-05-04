# frozen_string_literal: true

class LLM::Shell
  class Formatter
    def initialize(messages)
      @messages = messages
    end

    def format!(role)
      if role == :user
        format(messages.select(&:user?), color: :yellow, padding: 2)
      elsif role == :assistant
        format(messages.select(&:assistant?), color: :green)
      else
        raise ArgumentError, "unknown role: #{role}"
      end
    end

    private

    attr_reader :messages

    def format(messages, color: :yellow, padding: 1)
      messages.each(&:read!).flat_map do |message|
        [
          Paint[message.role, :bold, color], " says: ", "\n",
          wrap(message.content), "\n" * padding
        ]
      end.join
    end

    def wrap(text, width = 80)
      c = 0
      words = text.split(/ /)
      words.each_with_object(StringIO.new) do |word, io|
        c += word.length
        if word.empty?
          io << "\n"
          c = 0
        elsif c >= width
          io << "\n" << word << " "
          c = 0
        else
          io << word << " "
        end
      end.string
    end
  end
end
