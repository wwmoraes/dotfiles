function __fish_unique_values --description "removes duplicate values, keeping its first occurrence in order"
	set --local temp_values

	for value in $argv
		contains $value $temp_values; and continue

		set --append temp_values $value
	end

	printf "%s\n" $temp_values
end

function __fish_in_nix_shell --on-variable IN_NIX_SHELL
	set --local packages (string match --regex "/nix/store/[\w.-]+" $PATH)

	test (count $packages) -gt 0; or return

	fish_add_path --global --prepend $packages/bin

	## reset the complete path with non-nix store entries
	set --local temp_fish_complete_path (string match --invert --regex "/nix/store/[\w.-]+/.*" $fish_complete_path)
	## prepend nix store complete paths
	set --append temp_fish_complete_path \
		$packages/etc/fish/completions \
		$packages/share/fish/completions \
		$packages/share/fish/vendor_completions.d \
		;
	set --global fish_complete_path (__fish_unique_values $temp_fish_complete_path)

	## reset the function path with non-nix store entries
	set --local temp_fish_function_path (string match --invert --regex "/nix/store/[\w.-]+/.*" $fish_function_path)
	## prepend nix store function paths
	set --append temp_fish_function_path \
		$packages/etc/fish/functions \
		$packages/share/fish/functions \
		$packages/share/fish/vendor_functions.d \
		;
	set --global fish_function_path (__fish_unique_values $temp_fish_function_path)

	## reset the MANPATH with non-nix store entries
	set --local temp_MANPATH (string match --invert --regex "/nix/store/[\w.-]+/.*" $MANPATH)
	## prepend nix store MANPATH paths
	set --append temp_MANPATH $packages/share/man
	set --global MANPATH (__fish_unique_values $temp_MANPATH)

	## reset the INFOPATH with non-nix store entries
	set --local temp_INFOPATH (string match --invert --regex "/nix/store/[\w.-]+/.*" $INFOPATH)
	## prepend nix store INFOPATH paths
	set --append temp_INFOPATH $packages/share/info
	set --global INFOPATH (__fish_unique_values $temp_INFOPATH)
end
