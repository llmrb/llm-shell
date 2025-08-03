# frozen_string_literal: true

require "redcarpet"
require "coderay"

class LLM::Shell
  ##
  # @api private
  # @see redcarpet https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/markdown.h#L69-L110
  class Markdown < Redcarpet::Render::Base
    def self.render(text)
      renderer = Redcarpet::Markdown.new(self, options)
      renderer.render(text).strip
    end

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
      Paint[("#" * level) + " " + text, color]
    end

    def paragraph(p) = "#{p.gsub(/(.{1,#{80}})(\s+|\Z)/, "\\1\n").strip}\n"
    def list(items, _type) = items
    def list_item(item, _type) = "\n• #{item.strip}\n"
    def emphasis(text) = Paint[text, :italic]
    def double_emphasis(text) = Paint[text, :bold]
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
