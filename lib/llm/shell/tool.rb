# frozen_string_literal: true

class LLM::Tool
  module Patch
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
  end

  extend Patch
end
