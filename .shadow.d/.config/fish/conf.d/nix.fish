function __nix_shell_reload_completions --on-variable IN_NIX_SHELL
	for dir in (string split ":" $XDG_DATA_DIRS)
		test -d $dir/fish/vendor_completions.d; or continue

		set -l files $dir/fish/vendor_completions.d/*.fish
		count $files > /dev/null; and source $files
	end
end
