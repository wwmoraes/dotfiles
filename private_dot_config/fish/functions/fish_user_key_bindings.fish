function fish_user_key_bindings
	# Execute this once per mode that emacs bindings should be used in
	fish_default_key_bindings -M insert

	# Then execute the vi-bindings so they take precedence when there's a conflict.
	# Without --no-erase fish_vi_key_bindings will default to
	# resetting all bindings.
	# The argument specifies the initial mode (insert, "default" or visual).
	fish_vi_key_bindings --no-erase insert

	# Ctrl-A: save previous command as a snippet
	bind \ca __snippet-new
	bind -M insert \ca __snippet-new
	# Ctrl-V: select a snippet
	bind \cv __snippet-select
	bind -M insert \cv __snippet-select
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
