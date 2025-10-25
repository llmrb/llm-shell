## About

llm-shell is an extensible, developer-oriented command-line
console that can interact with multiple Large Language Models
(LLMs). It serves as both a demo of the [llmrb/llm](https://github.com/llmrb/llm)
library and a tool to help improve the library through real-world
usage and feedback.

## Demo

<details>
  <summary>Show</summary>
  <img src="share/llm-shell/examples/demo.gif/">
</details>

## Features

#### General

- 🌟 Unified interface for multiple Large Language Models (LLMs)
- 🤝 Supports Gemini, OpenAI, Anthropic, xAI (grok), DeepSeek, LlamaCpp and Ollama

#### Customize

- 📤 Attach local files as conversation context
- 🔧 Extend with your own functions and tool calls
- 🚀 Extend with your own console commands

#### Shell

- 🤖 Builtin auto-complete powered by Readline
- 🎨 Builtin syntax highlighting powered by Coderay
- 📄 Deploys the less pager for long outputs
- 📝 Advanced Markdown formatting and output


## Customization

#### Tools

> For security and safety reasons, a user must confirm the execution of
> all function calls before they happen


Tools are loaded at boot time. Custom tools can be added to the
`${HOME}/.local/share/llm-shell/tools/` directory. The tools are
shared with the LLM and the LLM can request their execution.
The LLM is also made aware of a tool's return value after
it has been called.
See the
[tools/](lib/llm/shell/tools/)
directory for more examples:


```ruby
class System < LLM::Tool
  name "system"
  description "Run a system command"
  param :command, String, "The command to execute", required: true

  def call(command:)
    ro, wo = IO.pipe
    re, we = IO.pipe
    Process.wait Process.spawn(command, out: wo, err: we)
    [wo,we].each(&:close)
    {stderr: re.read, stdout: ro.read}
  end
end
```

#### Commands

llm-shell can be extended with your own console commands that take
precendence over messages sent to the LLM. Custom commands can be
added to the `${HOME}/.local/share/llm-shell/commands/` directory.
See the
[commands/](lib/llm/shell/commands/)
directory for more examples:

```ruby
class SayHello < LLM::Command
  name "say-hello"
  description "Say hello to somebody"

  def call(name)
    io.rewind.print "Hello, #{name}!"
  end
end
```

#### Prompts

> It is recommended that custom prompts instruct the LLM to emit markdown,
> otherwise you might see unexpected results because llm-shell assumes the LLM
> will emit markdown.

The prompt can be changed by adding a file to the `${HOME}/.local/share/llm-shell/prompts/`
directory, and then choosing it at boot time with the `-r PROMPT`, `--prompt PROMPT`
options. Generally you probably want to fork [default.txt](share/llm-shell/prompts/default.txt)
to conserve the original prompt rules around markdown and files, then modify it to
suit your own needs and preferences.

## Settings


The console client can be configured at the command line through option switches,
or through a TOML file. The TOML file can contain the same options that could be
specified at the command line. For cloud providers the key option is the only
required parameter, everything else has defaults. The TOML file is read from the
path `${HOME}/.llm-shell/config.toml` and it has the following format:

```toml
# ~/.config/llm-shell.toml

[openai]
key = "YOURKEY"

[gemini]
key = "YOURKEY"

[anthropic]
key = "YOURKEY"

[xai]
key = "YOURKEY"

[deepseek]
key = "YOURKEY"

[ollama]
host = "localhost"
model = "deepseek-coder:6.7b"

[llamacpp]
host = "localhost"
model = "qwen3"
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
    -r, --prompt [PROMPT]    Optional. The prompt to use.
    -v, --version            Optional. Print the version and exit
```

## Install

llm-shell can be installed via [rubygems.org](https://rubygems.org/gems/llm-shell)

	gem install llm-shell

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/)
<br>
See [LICENSE](./LICENSE)
