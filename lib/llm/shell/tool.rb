# frozen_string_literal: true

class LLM::Tool
  module Patch
    ##
    # Returns true for an enabled tool
    # @return [Boolean]
    def enabled?
      @enabled
    end

    ##
    # Enable the tool
    # @return [void]
    def enable!
      @enabled = true
    end

    ##
    # Disable the tool
    # @return [void]
    def disable!
      @enabled = false
    end

    ##
    # @return [Boolean]
    def builtin?
      path, _ = instance_method(:call).source_location
      path&.include?(LLM::Shell.root)
    end
  end

  m = method(:inherited)
  define_singleton_method(:inherited) do |tool|
    LLM::Shell.tools << tool
    m.call(tool)
    tool.enable!
  end

  extend Patch
end
