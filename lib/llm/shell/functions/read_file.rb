# frozen_string_literal: true

module LLM::Shell::Functions
  class ReadFile
    def call(path:)
      {ok: true, content: File.read(path)}
    rescue => ex
      {ok: false, error: {class: ex.class.to_s, message: ex.message}}
    end

    private

    LLM.function(:read_file) do |fn|
      fn.description "Read the contents of a file"
      fn.params do |schema|
        schema.object(path: schema.string.required)
      end
      fn.register(self)
    end
  end
end

