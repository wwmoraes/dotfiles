function watchrun -d "watch for file changes and run command on events"
  if test (count $argv) -lt 2
    echo "usage: "(status function)" <path> <command>"
    echo "usage: "(status function)" <path1>..[pathN] -- <command>"
    return 2
  end

  if set -l index (contains -i -- "--" $argv)
    set paths $argv[1..(expr $index - 1)]
    set cmd $argv[(expr $index + 1)..-1]
  else
    set paths $argv[1]
    set cmd $argv[2..-1]
  end

  fswatch -o $paths | xargs -n 1 sh -c "clear; date; $cmd"
end
