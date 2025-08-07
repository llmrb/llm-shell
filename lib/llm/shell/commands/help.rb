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
      pager do |io|
        render_commands(io)
        render_functions(io)
      end
    end

    private

    def render_commands(io)
      io.print(Paint["Commands", :bold, :underline], "\n\n")
      io.print(Paint["Builtin", :bold], "\n\n")
      render_command_subset commands.select(&:builtin?), io
      io.print(Paint["User", :bold], "\n\n")
      render_command_subset commands.reject(&:builtin?), io
      if commands.reject(&:builtin?).empty?
        io.print(Paint["No user commands available", :yellow], "\n\n")
      end
    end

    def render_functions(io)
      io.print(Paint["Functions", :bold, :underline], "\n\n")
      io.print(Paint["Builtin", :bold], "\n\n")
      render_function_subset functions.select(&:builtin?), io
      io.print(Paint["User", :bold], "\n\n")
      render_function_subset functions.reject(&:builtin?), io
      if functions.reject(&:builtin?).empty?
        io.print(Paint["No user functions available", :yellow], "\n\n")
      end
    end

    def render_command_subset(commands, io)
      commands.each.with_index(1) do |command, index|
        io.print(command_name(command, index, :cyan), "\n")
        io.print(command_desc(command), "\n\n")
      end
    end

    def render_function_subset(functions, io)
      functions.each.with_index(1) do |function, index|
        io.print(command_name(function, index, :blue), "\n")
        io.print(command_desc(function), "\n\n")
      end
    end

    def commands = LLM.commands.values.sort_by(&:name)
    def functions = LLM.functions.values.sort_by(&:name)
    def command_name(command, index, bgcolor) = [Paint[" #{index} ", :white, bgcolor, :bold], " ", Paint[command.name, :bold]].join
    def command_desc(command) = command.description || "No description"

    LLM.command "help" do |cmd|
      cmd.description "Show the help menu"
      cmd.register(self)
      cmd.builtin!
    end
  end
end
