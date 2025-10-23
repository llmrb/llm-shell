# frozen_string_literal: true

namespace :deps do
  desc "Install dependencies into place"
  task :install do
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
  task :rec, [:outfile] do |t, args|
    outfile = File.join("share", "llm-shell", "casts", args[:outfile])
    Kernel.spawn("asciinema", "rec", outfile)
    Process.wait
  end

  task :gif, [:infile, :outfile] do |t, args|
    infile  = File.join("share", "llm-shell", "casts", args[:infile])
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
