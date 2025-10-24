# frozen_string_literal: true

module LLM::Shell::Tools
  class System < LLM::Tool
    name "system"
    description "Run a system command"
    param :command, String, "The command to execute", required: true

    def call(command:)
      ro, wo = IO.pipe
      re, we = IO.pipe
      Process.wait Process.spawn(command, out: wo, err: we)
      [wo, we].each(&:close)
      {stderr: re.read, stdout: ro.read}
    end
  end
end
