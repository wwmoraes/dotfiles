set -q DOTFILES_DIR; or set -U DOTFILES_DIR $HOME/.files

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
    case config
      _dotfiles_config $argv[2..-1]
    case cd
      cd $DOTFILES_DIR
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec dotfiles
complete -xc dotfiles -n __fish_use_subcommand -a cd -d "navigate to the dotfiles folder"

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
  set tool (find $DOTFILES_DIR/ -maxdepth 1 -type d -not -name '.*' -exec basename {} \; | fzf --prompt="Choose project to add the file ")

  if test (string length $tool || echo 0) -eq 0
    read -P 'New tool folder: ' tool
    if test -d $DOTFILES_DIR/$tool
      echo "Folder for tool $tool already exists"
      return 1
    end
  end

  set destination (string replace $HOME $DOTFILES_DIR/$tool $file)

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
  pushd $DOTFILES_DIR > /dev/null
  stow -t ~ -R "$tool"
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a add -d "add and stow new file to dotfiles"

# install subcommand
function _dotfiles_install
  pushd $DOTFILES_DIR > /dev/null
  make install
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a install -d "[re]install dotfiles"

# update subcommand
function _dotfiles_update
  pushd $DOTFILES_DIR > /dev/null
  git pull
  make install
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a update -d "update dotfiles"

# setup subcommand
function _dotfiles_setup
  pushd $DOTFILES_DIR > /dev/null
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

  code $DOTFILES_DIR
end
complete -xc dotfiles -n __fish_use_subcommand -a code -d "open VSCode on dotfiles' repository"

# lg subcommand
function _dotfiles_lg
  # Check the presence of needed tools
  if not type -q lazygit
    echo "Error: please install lazygit to use this function"
    return 1
  end

  pushd $DOTFILES_DIR > /dev/null
  lazygit
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a lg -d "open lazygit at dotfiles repository"

function _dotfiles_config -a opt

  switch "$opt"
    case gcloud
      set -l yellow (tput setaf 3 || true)
      set -l normal (tput sgr0 || true)

      # Get active account
      set -l ACTIVE_ACCOUNT (gcloud auth list --filter=status:ACTIVE --format="value(account)")
      # Get current accounts
      set -l ACCOUNTS (gcloud auth list --format="value(account)" | sed "s/$ACTIVE_ACCOUNT/$yellow$ACTIVE_ACCOUNT$normal/")

      if not test -z $ACCOUNTS
        # Offer to activate an already-authenticated account
        set -l SELECTED_ACCOUNT (echo $ACCOUNTS | fzf --ansi --prompt="Select account to activate ")
        if test (string length $SELECTED_ACCOUNT || echo 0) -ne 0
          gcloud config set account $SELECTED_ACCOUNT
          return
        end
      end

      # Authenticate a new account
      gcloud auth login --brief
      gcloud config config-helper

    case "" "*"
      echo "valid options: gcloud"
  end

end
complete -xc dotfiles -n __fish_use_subcommand -a config -d "configures other tools"
