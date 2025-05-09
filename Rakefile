# frozen_string_literal: true

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
