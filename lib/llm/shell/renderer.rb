# frozen_string_literal: true

class LLM::Shell
  class Renderer
    RenderError = Class.new(RuntimeError)

    ##
    # @param [LLM::Message] message
    #  The message to render
    # @return [LLM::Shell::MessageRenderer]
    #  Returns an instance of the renderer
    def initialize(message)
      @message = message
    end

    def render
      if message.user?
        render_message(message, :yellow)
      elsif message.assistant?
        render_message(message, :green)
      elsif message.system?
        render_message(message, :red)
      else
        raise RenderError.new("no handler for message role '#{message.role}'")
      end
    end

    private

    attr_reader :message

    def render_message(message, color)
      role    = Paint[message.role, :bold, color]
      title   = "#{role} says: "
      content = message.content
      if message.tool_call?
        body = "Tool call(s) request"
      elsif message.tool_return?
        body = "Tool call(s) return"
      elsif Array === content
        body = content.map { |c| render_message(c, color) }.join("\n")
      elsif content =~ file_pattern
        path = content.match(file_pattern) ? Regexp.last_match[1] : nil
        body = "<file path=#{path} />"
      else
        body = Markdown.render(content)
      end
      [title, "\n", body, "\n"].join
    end
  end
end
