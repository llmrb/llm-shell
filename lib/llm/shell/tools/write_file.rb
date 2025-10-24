# frozen_string_literal: true

module LLM::Shell::Tools
  class WriteFile < LLM::Tool
    name "write-file"
    description "Write the contents of a file"
    params do |schema|
      schema.object(
        path: schema.string.required,
        content: schema.string.required
      )
    end
    builtin!

    def call(path:, content:)
      {ok: true, content: File.binwrite(path, content)}
    rescue => ex
      {ok: false, error: {class: ex.class.to_s, message: ex.message}}
    end
  end
end
