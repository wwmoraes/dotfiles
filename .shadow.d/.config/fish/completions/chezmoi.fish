command -q chezmoi; or exit

chezmoi completion fish | source

function __chezmoi_scripts
	printf "%s\tChezmoi Script\n" (chezmoi managed ~/.chezmoiscripts/ | xargs -n1 basename)
end

complete -xc chezmoi -n '__fish_use_subcommand' -a env -d "Updates environment variables"
complete -xc chezmoi -n '__fish_use_subcommand' -a lg -d "Open lazygit in the chezmoi source path"
complete -xc chezmoi -n '__fish_use_subcommand' -a run -d "Execute a script"
complete -xc chezmoi -n '__fish_use_subcommand' -a sync -d "Updates environment with the latest brew bundle settings"
complete -xc chezmoi -n '__fish_seen_subcommand_from run' -a "(__chezmoi_scripts)"
