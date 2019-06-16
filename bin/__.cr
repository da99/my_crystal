

if `uname -m`.strip != "x86_64"
  STDERR.puts "!!! Only 64-bit architecures supported."
  STDERR.puts "!!! (Only 512 fibers allowed in 32-bit architectures.)"
  Process.exit 2
end


puts "works"
