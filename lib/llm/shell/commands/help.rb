# frozen_string_literal: true

class LLM::Shell
  class Command::Help < Command
    name "help"
    description "Show help"

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
      render_group commands.select(&:builtin?), io, :cyan
      io.print(Paint["User", :bold], "\n\n")
      render_group commands.reject(&:builtin?), io, :cyan
    end

    def render_functions(io)
      io.print(Paint["Functions", :bold, :underline], "\n\n")
      io.print(Paint["Builtin", :bold], "\n\n")
      render_group functions.select(&:builtin?), io, :blue
      io.print(Paint["User", :bold], "\n\n")
      render_group functions.reject(&:builtin?), io, :blue
    end

    def render_group(commands, io, bgcolor)
      if commands.empty?
        io.print(Paint["None available", :yellow], "\n\n")
      else
        commands.each.with_index(1) do |command, index|
          io.print(name(command, index, bgcolor), "\n")
          io.print(desc(command), "\n\n")
        end
      end
    end

    def commands = LLM::Shell.commands.sort_by(&:name)
    def functions = LLM::Shell.tools
    def name(command, index, bgcolor) = [Paint[" #{index} ", :white, bgcolor, :bold], " ", Paint[command.name, :bold]].join
    def desc(command) = command.description || "No description"
  end
end
