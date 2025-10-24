# frozen_string_literal: true

module LLM::Shell::Tools
  class ReadFile < LLM::Tool
    name "read-file"
    description "Read the contents of a file"
    params { |schema| schema.object(path: schema.string.required) }
    builtin!
    
    def call(path:)
      {ok: true, content: File.read(path)}
    rescue => ex
      {ok: false, error: {class: ex.class.to_s, message: ex.message}}
    end

    function.builtin!
  end
end
