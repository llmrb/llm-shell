# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "llm-shell"
  spec.version = "0.1.0"
  spec.authors = ["Antar Azri", "0x1eef"]
  spec.email = ["azantar@proton.me", "0x1eef@proton.me"]

  spec.summary = "llm-shell provides a simple command line interface " \
                 "to multiple LLM providers."
  spec.description = spec.summary
  spec.homepage = "https://github.com/llmrb/llm-shell"
  spec.license = "0BSDL"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir[
    "README.md", "LICENSE",
    "lib/*.rb", "lib/**/*.rb",
    "libexec/*", "libexec/**/*",
    "bin/*", "llm.gemspec"
  ]
  spec.require_paths = ["lib"]
  spec.executables = ["llm-shell"]
  spec.add_dependency "llm.rb", "~> 0.5"
  spec.add_dependency "io-line.rb", "~> 0.1.0"
  spec.add_dependency "paint", "~> 2.1"
  spec.add_dependency "kramdown", "~> 2.5"

  spec.add_development_dependency "webmock", "~> 3.24.0"
  spec.add_development_dependency "yard", "~> 0.9.37"
  spec.add_development_dependency "kramdown", "~> 2.4"
  spec.add_development_dependency "webrick", "~> 1.8"
  spec.add_development_dependency "test-cmd.rb", "~> 0.12.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.40"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "dotenv", "~> 2.8"
end
