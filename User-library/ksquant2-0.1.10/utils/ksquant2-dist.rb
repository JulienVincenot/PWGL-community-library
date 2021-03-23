def safe_system(command)
  puts command
  system command
  res = $?
  if not (res == 0) then
    puts "`" + command + "'"
    puts "returned " + res.to_s
    exit 1
  end
end


safe_system "git status | grep 'nothing to commit (working directory clean)'"

puts "version:"
version = readline.chomp
puts version.inspect

# safe_system "git tag -a #{version}"
safe_system "make clean"
safe_system "make"
safe_system "sh utils/link.sh"
safe_system "otool -L Main > otool.out"
safe_system "! grep libgmp <otool.out"
safe_system "rm otool.out"
safe_system "mv Main kernel"
safe_system "git archive --prefix=justtemp/ --format tar -o /tmp/justtemp.tar HEAD"
safe_system "cd /tmp; rm -rf justtemp ; tar xf justtemp.tar"
safe_system "mv kernel /tmp/justtemp"
safe_system "cd /tmp; mv  justtemp ksquant2-#{version}"
safe_system "cd /tmp; tar cfz ksquant2-#{version}.tgz ksquant2-#{version}"
