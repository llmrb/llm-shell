# frozen_string_literal: true

class LLM::Shell
  class Markdown
    require "kramdown"
    require "coderay"

    ##
    # @param [String] text
    # @return [LLM::Shell::Markdown]
    def initialize(text)
      @document = Kramdown::Document.new preprocessor(text)
    end

    ##
    # @return [String]
    def to_ansi
      @document.root.children.map { |node| visit(node) }.join("\n")
    end

    private

    def visit(node)
      case node.type
      when :header
        level = node.options[:level]
        color = levels[level]
        Paint[("#" * level) + " " + node.children.map { visit(_1) }.join, color]
      when :p
        node.children.map { visit(_1) }.join
      when :ul
        node.children.map { visit(_1) }.join("\n")
      when :li
        "• " + node.children.map { visit(_1) }.join
      when :em
        Paint[node.children.map { visit(_1) }.join, :italic]
      when :strong
        Paint[node.children.map { visit(_1) }.join, :bold]
      when :br
        "\n"
      when :codespan, :codeblock
        lines = node.value.each_line.to_a
        lang  = lines[0].strip
        code  = lines[1..].join
        if lines.size == 1
          Paint[node.value, :italic]
        else
          ["\n", Paint[">>> #{lang}", :blue, :bold],
           "\n\n", coderay(code, lang),
           "\n", Paint["<<< #{lang}", :blue, :bold]].join
        end
      when :text
        node.value
      else
        node.children.map { visit(_1) }.join
      end
    end

    def levels
      {
        1 => :green, 2 => :blue, 3 => :green,
        4 => :yellow, 5 => :red, 6 => :purple
      }
    end

    def preprocessor(text)
      text
        .gsub(/([^\n])\n(#+ )/, "\\1\n\n\\2")
        .gsub(/(#+ .+?)\n(?!\n)/, "\\1\n\n")
        .gsub(/\A<think>[\n]*<\/think>(?:\n)/, "")
        .gsub(/\A\n{2,}/, "")
    end

    def coderay(code, lang)
      CodeRay.scan(code, lang).terminal
    rescue ArgumentError
      lang = "text"
      retry
    end
  end
end
