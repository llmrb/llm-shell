# frozen_string_literal: true

desc "Run formatter"
task :fmt do
  files = `git ls-files`.each_line
  files = files.filter_map { _1.chomp.end_with?(".rb") ? _1.chomp : nil }
  system "bundle exec rubocop -c .rubocop.yml -A #{files.join(' ')}"
end

namespace :deps do
  desc "Initialize git submodules"
  task :init do
    sh "git submodule update --init --recursive"
  end

  desc "Install dependencies into place"
  task install: %i[init] do
    Dir[File.join("packages", "*")].each do |dir|
      target = File.join(__dir__, "lib", "llm", "shell", "internal", File.basename(dir))
      mkdir_p(target)
      cp_r File.join(dir, "lib"), target
      cp_r Dir[File.join(dir, "*LICENSE*")], target
      cp_r Dir[File.join(dir, "license_*")], target
      cp_r Dir[File.join(dir, "BSDL")], target
    end
  end
end

namespace :asciinema do
  desc "Record the terminal with asciinema"
  task :rec, [:outfile] do |t, args|
    outfile = File.join("share", "llm-shell", "casts", args[:outfile])
    Kernel.spawn("asciinema", "rec", outfile)
    Process.wait
  end

  desc "Convert cast to gif"
  task :gif, [:infile, :outfile] do |t, args|
    infile  = File.join("share", "llm-shell", "examples", args[:infile])
    outfile = File.join("share", "llm-shell", "examples", args[:outfile])
    Kernel.spawn(
      "agg",
      "--font-size", "24",
      "--cols", "80",
      "--rows", "15",
      infile, outfile
    )
    Process.wait
  end
end
