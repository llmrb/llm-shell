## About

llm-shell is a command line utility that provides an interface to multiple
large language models (LLMs). It primarily serves as a demo of the
[llmrb/llm](https://github.com/llmrb/llm) library, and it was implemented
to showcase the library's capabilities, and also to improve the library
from what was learned along the way.

## Features

- 🌟 A single interface for multiple Large Language Models (LLMs)
- 🤝 Gemini, OpenAI, Anthropic and Ollama support
- 📤 Attach local files as additional conversation context
- 📝 Advanced formatting with Markdown

## Demos

#### Demo #1

![demo](share/llm-shell/examples/example2.gif)

#### Demo #2

![demo](share/llm-shell/examples/example1.gif)

## Settings

#### YAML

The console client can be configured at the command line through option switches,
or through a YAML file. The YAML file can generally contain the same options that
could be specified at the command line. For cloud providers the token is the only
required parameter, everything else has defaults. The YAML file is read from the
path `${HOME}/.llm-shell/config.yml` and it has the following format:

```yaml
# ~/.config/llm-shell.yml
openai:
  token: YOURTOKEN
  model: gpt-4o-mini
gemini:
  token: YOURTOKEN
  model: gemini-2.0-flash-001
anthropic:
  token: YOURTOKEN
  model: claude-3-7-sonnet-20250219
ollama:
  host: localhost
  model: deepseek-coder:6.7b
```

## Install

llm-shell can be installed via [rubygems.org](https://rubygems.org/gems/llm-shell)

	gem install llm-shell

## License

[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/)
<br>
See [LICENSE](./LICENSE)
