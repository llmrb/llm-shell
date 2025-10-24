# frozen_string_literal: true

class LLM::Function
  ##
  # Returns true when a function is a built-in function
  # @return [Boolean]
  def builtin?
    @builtin
  end

  ##
  # Mark a function as a built-in function
  # @return [void]
  def builtin!
    @builtin = true
  end
end

class LLM::Tool
  def self.builtin!
    function.builtin!
  end

  def self.builtin?
    function.builtin?
  end
end