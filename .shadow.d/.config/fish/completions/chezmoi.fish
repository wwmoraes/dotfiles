source (brew --prefix)/share/fish/vendor_completions.d/chezmoi.fish

complete -xc chezmoi -n '__fish_use_subcommand' -a check -d "Dry-run report of package changes"
complete -xc chezmoi -n '__fish_use_subcommand' -a lg -d "Open lazygit at the chezmoi source path"
complete -xc chezmoi -n '__fish_use_subcommand' -a sync -d "Re-applies the brew bundle"
