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
        io.print(Paint["Help", :bold, :underline], "\n\n")
        render_commands(io)
        io.print("\n")
        render_functions(io)
      end
    end

    private

    def render_commands(io)
      io.print(Paint["Commands", :bold, :underline], "\n\n")
      render_group(io, "Builtin", commands.select(&:builtin?), :cyan)
      io.print("\n")
      render_group(io, "User", commands.reject(&:builtin?), :cyan)
    end

    def render_functions(io)
      io.print(Paint["Functions", :bold, :underline], "\n\n")
      render_group(io, "Builtin (Enabled)", functions.select { |f|  f.builtin? && f.enabled? }, :blue)
      render_group(io, "Builtin (Disabled)", functions.select { |f|  f.builtin? && !f.enabled? }, :blue)
      io.print("\n")
      render_group(io, "User (Enabled)", functions.select { |f| !f.builtin? && f.enabled? }, :blue)
      render_group(io, "User (Disabled)", functions.select { |f| !f.builtin? && !f.enabled? }, :blue)
    end

    def render_group(io, title, items, color)
      io.print(Paint[title, :bold], "\n")
      if items.empty?
        io.print(Paint["  None available", :yellow], "\n")
      else
        items.each do |item|
          status = item.enabled? ? Paint["enabled", :green] : Paint["disabled", :red]
          io.print("  ", Paint[item.name, color, :bold], " - ", item.description || "No description", " (", status, ")\n")
        end
      end
    end

    def commands = LLM::Shell.commands.sort_by(&:name)
    def functions = LLM::Shell.tools.sort_by(&:name)
  end
end
