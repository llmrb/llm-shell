# frozen_string_literal: true

class IO::Line
  require "io/console"

  attr_reader :io

  def initialize(io)
    @io = io
  end

  def print(*strs)
    tap { @io.print(strs.join.gsub($/, "")) }
  end

  def end
    tap { @io.print($/) }
  end

  def rewind
    tap do
      @io.erase_line(2)
      @io.goto_column(0)
    end
  end
end
