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
    case update
      _dotfiles_update
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
    echo "Error: please pass a file/directory to add"
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
  set tool (find ~/.files/ -maxdepth 1 -not -name '.*' -type d -printf '%f\n' | fzf --prompt="Choose project to add the file ")

  if test (string length $tool || echo 0) -eq 0
    read -P 'New tool folder: ' tool
    if test -d $HOME/.files/$tool
      echo "Folder for tool $tool already exists"
      return 1
    end
  end

  set destination (string replace $HOME $HOME/.files/$tool $file)

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
  pushd ~/.files > /dev/null
  stow -t ~ -R "$tool"
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a add -d "add and stow new file to dotfiles"

# install subcommand
function _dotfiles_install
  pushd ~/.files > /dev/null
  make install
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a install -d "[re]install dotfiles"

# update subcommand
function _dotfiles_update
  pushd ~/.files > /dev/null
  git pull
  make install
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a update -d "update dotfiles"

# setup subcommand
function _dotfiles_setup
  pushd ~/.files > /dev/null
  make setup
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

  code ~/.files
end
complete -xc dotfiles -n __fish_use_subcommand -a code -d "open VSCode on dotfiles' repository"

# lg subcommand
function _dotfiles_lg
  # Check the presence of needed tools
  if not type -q lazygit
    echo "Error: please install lazygit to use this function"
    return 1
  end

  pushd ~/.files > /dev/null
  lazygit
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a lg -d "open lazygit at dotfiles repository"
