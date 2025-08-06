# frozen_string_literal: true

require "redcarpet"
require "coderay"

class LLM::Shell
  ##
  # @api private
  # @see redcarpet https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/markdown.h#L69-L110
  class Markdown < Redcarpet::Render::Base
    ##
    # Renders markdown text to a terminal-friendly format.
    # @return [String
    def self.render(text)
      renderer = Redcarpet::Markdown.new(self, options)
      renderer.render(wrap(p: text)).strip
    end

    ##
    # @api private
    def self.wrap(p:, width: 80)
      in_code = false
      p.lines.map do |line|
        if line =~ /^(\s*)(```|~~~)/
          in_code = !in_code
          line
        elsif in_code || line =~ /^\s{4}/
          line
        else
          line.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
        end
      end.join.strip + "\n"
    end

    ##
    # @api private
    def self.options
      {
        autolink: false, no_intra_emphasis: true,
        fenced_code_blocks: true, lax_spacing: true,
        strikethrough: true, superscript: true,
        tables: true, with_toc_data: true
      }
    end

    def block_code(code, lang)
      ["\n", Paint["#{lang}:", :blue, :bold],
       "\n", coderay(code, lang),
       "\n"].join
    end

    def header(text, level)
      color = levels.fetch(level, :white)
      "\n" + Paint[("#" * level) + " " + text, color] + "\n"
    end

    def paragraph(p) = "#{p.strip}\n\n"
    def list(items, _type) = items
    def list_item(item, _type) = "\n• #{item.strip}\n"
    def emphasis(text) = Paint[text, :italic]
    def double_emphasis(text) = Paint[text, :bold]
    def codespan(code) = Paint[code, :yellow, :underline]
    def block_quote(quote) = Paint[quote, :italic]
    def normal_text(text) = text
    def linebreak = "\n"

    private

    def coderay(code, lang)
      CodeRay.scan(code, lang).terminal
    rescue ArgumentError
      lang = "text"
      retry
    end

    def levels
      {
        1 => :green, 2 => :blue, 3 => :green,
        4 => :yellow, 5 => :red, 6 => :purple
      }
    end
  end
end
