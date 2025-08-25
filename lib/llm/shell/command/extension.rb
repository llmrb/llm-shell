# frozen_string_literal: true

class LLM::Shell::Command
  ##
  # The {LLM::Shell::Command::Extension LLM::Shell::Command::Extension}
  # module extends the `LLM` constant with methods that can provide shell
  # commands for an active llm-shell session.
  #
  # @example hello command
  #   LLM.command(:hello) do |cmd|
  #     cmd.define do |name|
  #       io.rewind.print("Hello #{name}")
  #     end
  #   end
  module Extension
    ##
    # @example
    #   LLM.command(:hello) do |cmd|
    #     cmd.define do |name|
    #       io.rewind.print("Hello #{name}")
    #     end
    #   end
    # @param [String] name
    #  The name of the command
    # @yieldparam [LLM::Shell::Command] cmd
    #  Yields an instance of LLM::Shell::Command
    # @return [void]
    def command(name)
      cmd = LLM::Shell::Command.new
      cmd.name(name)
      yield cmd
      commands[cmd.name] = cmd
    end

    ##
    # @return [Hash<String, LLM::Shell::Command>]
    def commands
      @commands ||= {}
    end
  end
  LLM.extend(Extension)
end
