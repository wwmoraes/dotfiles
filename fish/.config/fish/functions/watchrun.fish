function watchrun -a path -d "watch for file changes and run command on events"
  if test (count $argv) -lt 2
    echo "usage: "(status function)" <path> <command>"
    return 2
  end
  set -e argv[1]
  fswatch -o $path | xargs -n1 -I{} $argv
end
