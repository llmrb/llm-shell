# frozen_string_literal: true

class LLM::Shell
  class Command::EnableTool < Command
    Error = Class.new(RuntimeError)

    name "enable-tool"
    description "Enable a tool"

    ##
    # Completes a tool name.
    # @param name [String]
    #  The tool name to complete.
    # @return [Array<String>]
    #  Returns the completed tool name(s)
    def self.complete(name)
      LLM::Shell.tools.map(&:name).select { _1.start_with?(name) }
    end

    ##
    # Enables the given tool.
    # @return [void]
    def call(name)
      tool = LLM::Shell.tools.find { _1.name == name }
      if tool
        tool.enable!
        io.rewind.print("tool enabled").end
      else
        raise Error, "unknown tool: #{name}"
      end
    end
  end
end