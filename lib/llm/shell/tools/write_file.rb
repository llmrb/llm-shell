# frozen_string_literal: true

module LLM::Shell::Tools
  class WriteFile < LLM::Tool
    name "write-file"
    description "Write the contents of a file"
    param :path, String, "The path to a file", required: true
    param :content, String, "The contents of a file", required: true

    def call(path:, content:)
      {ok: true, content: File.binwrite(path, content)}
    rescue => ex
      {ok: false, error: {class: ex.class.to_s, message: ex.message}}
    end
  end
end
