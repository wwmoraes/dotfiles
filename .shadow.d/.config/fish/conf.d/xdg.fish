function __reload_completions --on-variable XDG_DATA_DIRS
	for dir in (string split ":" $XDG_DATA_DIRS)
		test -d $dir/fish/vendor_completions.d
		or continue

		source $dir/fish/vendor_completions.d/*.fish
	end
end
