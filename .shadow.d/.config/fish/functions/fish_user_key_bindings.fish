function fish_user_key_bindings
	# Ctrl-A: save previous command as a snippet
	bind \ca __snippet-new
	# Ctrl-V: select a snippet
	bind \cv __snippet-select
end

function __snippet-select
	set -l cmd (snipkit print (commandline | string collect))
	test $status -eq 0
	and test -n "$cmd"
	and commandline --replace -- $cmd

	commandline -f repaint
end

function __snippet-new
	pet new (echo $history[1])
	commandline -f repaint
end
