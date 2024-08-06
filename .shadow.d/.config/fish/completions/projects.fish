function __projects_fish_complete_directories -d "Complete directory prefixes" --argument-names comp desc
  if not set -q desc[1]
    set desc Directory
  end

  if not set -q comp[1]
    set comp (commandline -ct)
  end

  # HACK: We call into the file completions by using a non-existent command.
  # If we used e.g. `ls`, we'd run the risk of completing its options or another kind of argument.
  # But since we default to file completions, if something doesn't have another completion...
  set -l dirs (complete -C"nonexistentcommandooheehoohaahaahdingdongwallawallabingbang $comp" | string match -r '.*/$' | xargs -I% expr "%" : "$comp\(.*\)")

  if set -q dirs[1]
    printf "%s\t$desc\n" $dirs
  end
end

complete -xc projects -n __fish_use_subcommand -a new -d "creates a project directory and initialize git on it"
complete -xc projects -n '__fish_seen_subcommand_from new' -a ""
complete -xc projects -n __fish_use_subcommand -a code -d "open project on VSCode"
complete -xc projects -n '__fish_seen_subcommand_from code' -a "(__projects_fish_complete_directories $PROJECTS_DIR/)"
complete -xc projects -n __fish_use_subcommand -a lg -d "open lazygit for a project"
complete -xc projects -n '__fish_seen_subcommand_from lg' -a "(__projects_fish_complete_directories $PROJECTS_DIR/)"
complete -xc projects -n __fish_use_subcommand -a cd -d "go to the projects or a specific project directory"
complete -xc projects -n '__fish_seen_subcommand_from cd' -a "(__projects_fish_complete_directories $PROJECTS_DIR/)"
complete -xc projects -n __fish_use_subcommand -a ls -d "list projects"
complete -xc projects -n __fish_use_subcommand -a update -d "update project files"
