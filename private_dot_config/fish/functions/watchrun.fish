function watchrun -d "watch for file changes and run command on events"
	command -q fswatch; or echo "fswatch is not installed" && return

	if test (count $argv) -lt 1
		echo "usage: "(status function)" <command>"
		echo "usage: "(status function)" <path> <command>"
		echo "usage: "(status function)" <path>[..pathN] -- <command>"
		return 2
	end

	if set -l index (contains -i -- "--" $argv)
		set paths $argv[1..(expr $index - 1)]
		set cmd $argv[(expr $index + 1)..-1]
	else
		set paths $argv[1]
		set cmd $argv[2..-1]

		test -n "$cmd"; or set cmd $paths
	end

	fswatch -o --event Updated $paths | xargs -n 1 sh -c "clear; date; $cmd"
end
