# frozen_string_literal: true

class LLM::Shell
  class Command::DisableTool < Command
    Error = Class.new(RuntimeError)
    name "disable-tool"
    description "Disable a tool"

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
    # Disables the given tool.
    # @return [void]
    def call(name)
      tool = LLM::Shell.tools.find { _1.name == name }
      if tool
        tool.disable!
        io.rewind.print("tool disabled").end
      else
        raise Error, "unknown tool: #{name}"
      end
    end
  end
end
