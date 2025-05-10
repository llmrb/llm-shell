## About

llm-shell is an extensible, developer-oriented command-line
console that can interact with multiple Large Language Models
(LLMs). It serves as both a demo of the [llmrb/llm](https://github.com/llmrb/llm)
library and a tool to help improve the library through real-world
usage and feedback. Jump to the [Demos](#demos) section to see
it in action!

## Features

#### General

- 🌟 Unified interface for multiple Large Language Models (LLMs)
- 🤝 Supports Gemini, OpenAI, Anthropic, LlamaCpp and Ollama

#### Customize

- 📤 Attach local files as conversation context
- 🔧 Extend with your own functions and tool calls
- 🚀 Extend with your own console commands

#### Shell

- 🤖 Builtin auto-complete powered by Readline
- 🎨 Builtin syntax highlighting powered by Coderay
- 📄 Deploys the less pager for long outputs
- 📝 Advanced Markdown formatting and output

## Demos

<details>
  <summary><b>1. Tools: "system" function</b></summary>
  <img src="share/llm-shell/examples/toolcalls.gif/">
</details>

<details>
  <summary><b>2. Files: import at boot time</b></summary>
  <img src="share/llm-shell/examples/files-boottime.gif">
</details>

<details>
<summary><b>3. Files: import at runtime</b></summary>
  <img src="share/llm-shell/examples/files-runtime.gif">
</details>

## Customization

#### Functions

> For security and safety reasons, a user must confirm the execution of
> all function calls before they happen and also add the function to
> an allowlist before it will be loaded by llm-shell automatically
> at boot time.

The `~/.llm-shell/tools/` directory can contain one or more
[llmrb/llm](https://github.com/llmrb/llm) functions that the
LLM can call once you confirm you are okay with executing the
code locally (along with any arguments it provides). See the
earlier demo for an example:

```ruby
LLM.function(:system) do |fn|
  fn.description "Run a shell command"
  fn.params do |schema|
    schema.object(command: schema.string.required)
  end
  fn.define do |params|
    ro, wo = IO.pipe
    re, we = IO.pipe
    Process.wait Process.spawn(params.command, out: wo, err: we)
    [wo,we].each(&:close)
    {stderr: re.read, stdout: ro.read}
  end
end
```

#### Commands

llm-shell can be extended with your own console commands. This can be
done by creating a Ruby file in the `~/.llm-shell/commands/` directory &ndash;
with one file per command. The commands are loaded at boot time. See the
[import-file](lib/llm/shell/commands/import_file.rb)
command for a realistic example:

```ruby
LLM.command "say-hello" do |cmd|
  cmd.description "Say hello to somebody"
  cmd.define do |name|
    io.rewind.print "Hello #{name}!"
  end
end
```
## Settings

#### YAML

The console client can be configured at the command line through option switches,
or through a YAML file. The YAML file can contain the same options that could be
specified at the command line. For cloud providers the key option is the only
required parameter, everything else has defaults. The YAML file is read from the
path `${HOME}/.llm-shell/config.yml` and it has the following format:

```yaml
# ~/.config/llm-shell.yml
openai:
  key: YOURKEY
  model: gpt-4o-mini
gemini:
  key: YOURKEY
  model: gemini-2.0-flash-001
anthropic:
  key: YOURKEY
  model: claude-3-7-sonnet-20250219
ollama:
  host: localhost
  model: deepseek-coder:6.7b
llamacpp:
  host: localhost
  model: qwen3
tools:
  - system
```

## Usage

#### CLI

```bash
Usage: llm-shell [OPTIONS]
    -p, --provider NAME      Required. Options: gemini, openai, anthropic, ollama or llamacpp.
    -k, --key [KEY]          Optional. Required by gemini, openai, and anthropic.
    -m, --model [MODEL]      Optional. The name of a model.
    -h, --host [HOST]        Optional. Sometimes required by ollama.
    -o, --port [PORT]        Optional. Sometimes required by ollama.
    -f, --files [GLOB]       Optional. Glob pattern(s) separated by a comma.
    -t, --tools [TOOLS]      Optional. One or more tool names to load automatically.
```

## Install

llm-shell can be installed via [rubygems.org](https://rubygems.org/gems/llm-shell)

	gem install llm-shell

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/)
<br>
See [LICENSE](./LICENSE)
