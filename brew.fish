function brew-arm
  eval (/opt/homebrew/bin/brew shellenv)
  # set -gx HOMEBREW_PREFIX "/opt/homebrew"
  # set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
  # set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
  # set -q PATH; or set PATH ''; set -gx PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH
  # set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH
  # set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH

  arch -arm64 /opt/homebrew/bin/brew $argv
end

function brew-intel
  eval (/usr/local/Homebrew/bin/brew shellenv)
  # set -gx HOMEBREW_PREFIX "/usr/local"
  # set -gx HOMEBREW_CELLAR "/usr/local/Cellar"
  # set -gx HOMEBREW_REPOSITORY "/usr/local/Homebrew"
  # set -q PATH; or set PATH ''; set -gx PATH "/usr/local/bin" "/usr/local/sbin" $PATH
  # set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/usr/local/share/man" $MANPATH
  # set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/usr/local/share/info" $INFOPATH

  /usr/local/Homebrew/bin/brew $argv
end

function brew-migrate
  brew-intel uninstall --force $argv
  brew-arm reinstall $argv
end

function _brew-arch-unused -a arch
  test (count $argv) -eq 1; or return
  functions -q brew-$arch; or return

  set -l brew brew-$arch

  set -l installedFormulas ($brew list --formula -1 | sort -u)
  set -l installedCasks ($brew list --cask -1 | sort -u)

  set -l dependencyFormulas (test -n "$installedFormulas"; and $brew info --formula --json=v2 $installedFormulas | jq -r '[.formulae[].build_dependencies, .formulae[].dependencies | .[]] | unique | .[]' | sort -u)

  set -l dependencyFormulasDependencies (test -n "$dependencyFormulas"; and $brew info --formula --json=v2 $dependencyFormulas | jq -r '[.formulae[].build_dependencies, .formulae[].dependencies | .[]] | unique | .[]' | sort -u)

  set -l dependencyCasks (test -n "$installedCasks"; and $brew info --cask --json=v2 $installedCasks | jq -r '[.casks[].depends_on.formula // [] | .[]] | unique | .[]' | sort -u)

  set -l dependencyCasksDependencies (test -n "$dependencyCasks"; and $brew info --formula --json=v2 $dependencyCasks | jq -r '[.formulae[].build_dependencies, .formulae[].dependencies | .[]] | unique | .[]' | sort -u)

  set -l desiredFormulas (cat ~/.files/.setup.d/packages/system.txt ~/.files/.setup.d/packages/darwin/system.txt ~/.files/.setup.d/packages/darwin/brew-services.txt ~/.files/.setup.d/packages/personal/system.txt | cut -d: -f1 | grep -vE "^-" | xargs -n1 basename | sort -u)

  set -l desiredCasks (cat ~/.files/.setup.d/packages/cask.txt ~/.files/.setup.d/packages/personal/cask.txt | cut -d\| -f1 | grep -vE "^-" | xargs -n1 basename | sort -u)

  set -l installed (echo $installedFormulas $installedCasks | xargs -n1 | sort -u)
  set -l desired (echo $desiredFormulas $desiredCasks | xargs -n1 | sort -u)
  set -l dependencies (echo $dependencyFormulas $dependencyFormulasDependencies $dependencyCasks $dependencyCasksDependencies | xargs -n1 | sort -u)
  set -l keep (echo $desired $dependencies | xargs -n1 | sort -u)

  comm -23 (echo $installed | xargs -n1 | psub) (echo $keep | xargs -n1 | psub)
end

function _brew-arch-autoremove -a arch
  test (count $argv) -eq 1; or return
  functions -q brew-$arch; or return

  _brew-arch-unused $arch | xargs -P4 -n1 brew-$arch uninstall --force
end

function brew-intel-unused
  _brew-arch-unused intel
end

function brew-intel-autoremove
  _brew-arch-autoremove intel
end

function brew-arm-unused
  _brew-arch-unused arm
end

function brew-arm-autoremove
  _brew-arch-autoremove arm
end

function brew-tag-cask
  brew info --cask --json=v2 $argv | jq -r '.casks[].artifacts[].app // [] | .[]' | while read -l entry
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

  brew-arm info --cask --json=v2 $argv | jq -r '[.casks[].artifacts[]?.uninstall[]?.pkgutil] | flatten | .[]' | sort -u | grep -v null | while read -l package
    pkgutil --only-dirs --files $package | grep -iE '(.app|.prefpane)$' | while read -l entry
      sudo tag -s 'source:Brew' "/$entry"
    end
  end
end

function brew-tag-casks
  brew info --cask --json=v2 (brew-arm list --cask -1) | jq -r '.casks[].artifacts[].app // [] | .[]' | while read -l entry
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

  brew-arm info --cask --json=v2 (brew-arm list --cask -1) | jq -r '[.casks[].artifacts[]?.uninstall[]?.pkgutil] | flatten | .[]' | sort -u | grep -v null | while read -l package
    pkgutil --regexp --only-dirs --files $package | grep -iE '(.app|.prefpane)$' | while read -l entry
      sudo tag -s 'source:Brew' "/$entry"
    end
  end
end

function mas-tag
  mas list | sed -E -e 's/[ ]+/ /g' -e 's/^[0-9]+ /\/Applications\//g' -e 's/ \([0-9.]+\)$/.app/g' | xargs -I{} sudo tag -s 'source:Store' "{}"
end

function pkg-tag
  set -l packages 'com.displaylink.*' 'com.touch-base.*' 'com.displaylink.*'
  for package in $packages
    pkgutil --regexp --only-dirs --files $package | grep -iE '(.app|.prefpane)$' | while read -l entry
      set -l options "/$entry" "/Applications/$entry"
      for option in $options
        test -d "$option"; or continue
        echo "tagging $option"
        sudo tag -s 'source:Package' "$option"
        break
      end
    end
  end
end

functions -e function brew-intel-clean
