command -q chezmoi; or exit

source (brew --prefix)/share/fish/vendor_completions.d/chezmoi.fish

complete -xc chezmoi -n '__fish_use_subcommand' -a check -d "Dry-run report of package changes"
complete -xc chezmoi -n '__fish_use_subcommand' -a env -d "Updates environment variables"
complete -xc chezmoi -n '__fish_use_subcommand' -a lg -d "Open lazygit in the chezmoi source path"
complete -xc chezmoi -n '__fish_use_subcommand' -a run -d "Execute a script"
complete -xc chezmoi -n '__fish_use_subcommand' -a 'switch' -d "Builds and activates the latest nix profile settings"
complete -xc chezmoi -n '__fish_use_subcommand' -a sync -d "Updates environment with the latest brew bundle settings"
complete -xc chezmoi -n '__fish_seen_subcommand_from run' -a "(__chezmoi_scripts)"

function __chezmoi_scripts
  printf "%s\tChezmoi Script\n" (chezmoi managed ~/.chezmoiscripts/ | xargs -n1 basename)
end
