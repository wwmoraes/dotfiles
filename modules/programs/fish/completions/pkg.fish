complete -xc pkg -n __fish_use_subcommand -a list -d "lists all installed packages"

complete -xc pkg -n __fish_use_subcommand -a uninstall -d "removes files and directories related to a package"
complete -xc pkg -n '__fish_seen_subcommand_from uninstall' -a "(pkgutil --pkgs)"

complete -xc pkg -n __fish_use_subcommand -a list-files -d "lists files installed by an specific package"
complete -xc pkg -n '__fish_seen_subcommand_from list-files' -a "(pkgutil --pkgs)"

complete -xc pkg -n __fish_use_subcommand -a forget -d "uninstalls and forgets a package"
complete -xc pkg -n '__fish_seen_subcommand_from forget' -a "(pkgutil --pkgs)"
