# dotfiles main command
function dotfiles -a cmd -d "Setup dotfiles"
  switch "$cmd"
    case add
      if not isatty
        while read -l arg
          set argv $argv $arg
        end
      end

      _dotfiles_add $argv
    case code
      _dotfiles_code
    case install
      _dotfiles_install
    case lg
      _dotfiles_lg
    case setup
      _dotfiles_setup
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec dotfiles

# add subcommand
function _dotfiles_add
  # Check the presence of needed tools
  if not type -q fzf
    echo "Error: please install fzf to use this function"
    return 1
  end

  # Check and get file path
  set -e argv[1]
  if test (count $argv) != 1
    echo "Error: please pass a directory to add"
    return 1
  end

  set file $argv[1]

  # Check if file isn't a symbolic link already
  if test -L $file
    echo "Error: $file is a symbolic link already"
    return 1
  end

  set file (realpath $argv[1])

  # Check if file is under the home directory
  if not string match -q -- "$HOME/*" $file
    echo "Error: can't add files outside of your home"
    return 1
  end

  # Check if the file is really a file LOL
  if not test -f $file
    echo "Error: only files can be added"
    return 1
  end

  # Gets the tool folder
  set tool (find ~/.dotfiles/ -maxdepth 1 -not -name '.*' -type d -printf '%f\n' | fzf --prompt="Choose project to add the file ")

  set destination (string replace $HOME $HOME/.dotfiles/$tool $file)

  echo "Tool: $tool"
  printf "Source: %s\n" (string replace $HOME "~" $file)
  printf "Destination: %s\n" (string replace $HOME "~" $destination)

  echo
  echo "The file will be moved and stow'ed back."
  confirm "Proceed?"
  if test $status != 0
    return 0
  end

  echo
  echo "preparing directory..."
  mkdir -p (dirname $destination)

  echo "moving file..."
  cp "$file" "$destination"
  rm "$file"

  echo "stowing back file..."
  pushd ~/.dotfiles > /dev/null
  stow -t ~ -R "$tool"
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a add -d "add and stow new file to dotfiles"

# install subcommand
function _dotfiles_install
  pushd ~/.dotfiles > /dev/null
  make install
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a install -d "[re]install dotfiles"

# setup subcommand
function _dotfiles_setup
  pushd ~/.dotfiles > /dev/null
  bash ./setup.sh
  echo "Updating font cache..."
  fc-cache -f
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a setup -d "setup environment for dotfiles"

# code subcommand
function _dotfiles_code
  # Check the presence of needed tools
  if not type -q code
    echo "Error: please install VSCode to use this function"
    return 1
  end

  code ~/.dotfiles
end
complete -xc dotfiles -n __fish_use_subcommand -a code -d "open VSCode on dotfiles' repository"

# lg subcommand
function _dotfiles_lg
  # Check the presence of needed tools
  if not type -q lazygit
    echo "Error: please install lazygit to use this function"
    return 1
  end

  pushd ~/.dotfiles > /dev/null
  lazygit
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a lg -d "open lazygit at dotfiles repository"
