function pour -a cmd -w brew -d "helps serve brewed content the right way"
  command -q brew; or echo "brew is not installed" && return

  switch "$cmd"
    case "nuke"
      brew uninstall --force --zap $argv
    case "install"
      set -l formulas
      for arg in $argv[2..-1]
        string match -q -- '-*' $arg; and continue
        set -a formulas $arg
      end

      brew install $argv[2..-1]
      _pour_tags $formulas
    case "tags"
      _pour_tags $argv[2..-1]
    case "" "*"
      brew $argv
  end
end

function _pour_tags
  command -q brew; or echo "brew is not installed" && return
  command -q jq; or echo "jq is not installed" && return
  command -q tag; or echo "tag is not installed" && return
  command -q sudo; or echo "sudo is not installed" && return

  set -l casks $argv
  test (count $casks) -gt 0
  or set -l casks (brew list --cask -1)

  set -l casksJSON (brew info --cask --json=v2 $casks)

  echo $casksJSON | jq -r '.casks[].artifacts[].app // [] | .[] | .target? // .' | while read -l entry
    set -l artifact (string split -r -m 1 -f 2 "/" $entry)
    test -n "$artifact"; or set -l artifact $entry

    test -d "$HOME/Applications/$artifact"; and begin
      echo "@home $artifact"
      tag -s 'source:Brew' "$HOME/Applications/$artifact"
      continue
    end

    test -d "/Applications/$artifact"; and begin
      echo "@root $artifact"
      sudo tag -s 'source:Brew' "/Applications/$artifact"
      continue
    end

    echo "~404~ $artifact"
  end

  echo $casksJSON | jq -r '[.casks[].artifacts[]?.uninstall[]?.pkgutil] | flatten | .[]' | sort -u | grep -v null | while read -l package
    echo "@pkgs $package"
    pkgutil --regexp --only-dirs --files $package | grep -iE '(.app|.prefpane)$' | while read -l entry
      if test -d "/$entry"
        sudo tag -s 'source:Brew' "/$entry"
      else if test -d "/Applications/$entry"
        sudo tag -s 'source:Brew' "/Applications/$entry"
      else if test -d "/Library/PreferencePanes/$entry"
        sudo tag -s 'source:Brew' "/Library/PreferencePanes/$entry"
      else
        echo "file $entry not found, skipping"
      end
    end
  end
end
complete -xc pour -n __fish_use_subcommand -a tags -d "(re-)tag application bundles installed by brew"
