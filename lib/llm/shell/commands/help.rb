# frozen_string_literal: true

class LLM::Shell::Command
  class Help
    require_relative "utils"
    include Utils

    ##
    # @param [LLM::Shell::Context] context
    #  The context of the command
    # @return [LLM::Shell::Command::Help]
    def initialize(context)
      @context = context
    end

    ##
    # Prints help
    # @return [void]
    def call
      io.rewind.print(Paint["Commands", :bold, :underline]).end.end
      commands.each.with_index(1) do |command, index|
        io.rewind.print(command_name(command, index, :red)).end
        io.rewind.print(command_desc(command)).end.end
      end
      io.rewind.print(Paint["Functions", :bold, :underline]).end.end
      functions.each.with_index(1) do |fn, index|
        io.rewind.print(command_name(fn, index, :green)).end
        io.rewind.print(command_desc(fn)).end.end
      end
    end

    private

    def commands = LLM.commands.values.sort_by(&:name)
    def functions = LLM.functions.values.sort_by(&:name)
    def command_name(command, index, bgcolor) = [Paint[" #{index} ", :white, bgcolor, :bold], " ", Paint[command.name, :bold]].join
    def command_desc(command) = command.description || "No description"

    LLM.command "help" do |cmd|
      cmd.description "Shows help"
      cmd.register(self)
    end
  end
end
