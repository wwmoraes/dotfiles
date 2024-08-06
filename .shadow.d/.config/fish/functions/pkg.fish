function pkg -a cmd -w pkgutil -d "MacOS package management made easy"
  command -q pkgutil; or echo "pkgutil is not installed" && return

  switch "$cmd"
    case list
      pkgutil --pkgs
    case uninstall
      set -l package $argv[2]

      echo "uninstalling $package..."
      set -l files (pkgutil --only-files --files $package | string escape)
      ## Ask for the administrator password upfront
      sudo -v
      ## Keep-alive: update existing `sudo` time stamp until the parent has finished
      fish -c 'while true; sudo -n true; sleep 60; kill -0 "\$fish_pid" || exit; end 2>/dev/null' &
      set -l sudo_pid $last_pid
      disown $sudo_pid
      function _pkg_uninstall -V sudo_pid --on-event fish_postexec
        functions -e _pkg_uninstall
        kill $sudo_pid 2> /dev/null
      end

      echo "removing files..."
      sudo rm -rf (echo $files | xargs -n1 -P8 -I% echo /% | string escape)

      echo "removing empty directories..."
      set -l err (mkfifo (mktemp -u))
      sudo rmdir -p -v (echo $files | xargs dirname | string escape | sort -u | xargs -I % echo /%) 2>err | grep -v "No such file or directory\|Directory not empty" err
      rm -f $err
    case forget
    for package in $argv[2..-1]
      pkg uninstall $package
      echo "forgetting package $package..."
      sudo pkgutil --force --forget $package
      test -f "/Library/Apple/System/Library/Receipts/$package.bom"
      and sudo rm -f "/Library/Apple/System/Library/Receipts/$package.bom"
    end
    case list-files
      pkgutil --only-files --files $argv[2..-1]
    case "" "*"
      pkgutil $argv
  end
end

complete -xc pkg -n __fish_use_subcommand -a list -d "lists all installed packages"

complete -xc pkg -n __fish_use_subcommand -a uninstall -d "removes files and directories related to a package"
complete -xc pkg -n '__fish_seen_subcommand_from uninstall' -a "(pkgutil --pkgs)"

complete -xc pkg -n __fish_use_subcommand -a list-files -d "lists files installed by an specific package"
complete -xc pkg -n '__fish_seen_subcommand_from list-files' -a "(pkgutil --pkgs)"

complete -xc pkg -n __fish_use_subcommand -a forget -d "uninstalls and forgets a package"
complete -xc pkg -n '__fish_seen_subcommand_from forget' -a "(pkgutil --pkgs)"
