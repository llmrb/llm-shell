# frozen_string_literal: true

module LLM::Shell::Functions
  class WriteFile
    def call(path:, content:)
      {ok: true, content: File.binwrite(path, content)}
    rescue => ex
      {ok: false, error: {class: ex.class.to_s, message: ex.message}}
    end

    private

    LLM.function(:write_file) do |fn|
      fn.description "Write the contents of a file"
      fn.params do |schema|
        schema.object(path: schema.string.required, content: schema.string.required)
      end
      fn.register(self)
    end
  end
end
