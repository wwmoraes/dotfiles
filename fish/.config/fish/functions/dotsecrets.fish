set -q DOTSECRETS_DIR; or set -U DOTSECRETS_DIR $HOME/.secrets

# dotsecrets main command
function dotsecrets -a cmd -d "Setup dotsecrets"
  switch "$cmd"
    case add
      if not isatty
        while read -l arg
          set argv $argv $arg
        end
      end

      _dotsecrets_add $argv
    case install
      _dotsecrets_install
    case update
      _dotsecrets_update
    case code
      _dotsecrets_code
    case lg
      _dotsecrets_lg
    case setup
      _dotsecrets_setup
    case cd
      cd $DOTSECRETS_DIR
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec dotsecrets
complete -xc dotsecrets -n __fish_use_subcommand -a cd -d "navigate to the dotsecrets folder"

# add subcommand
function _dotsecrets_add
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
  set tool (find $DOTSECRETS_DIR/ -maxdepth 1 -type d -not -name '.*' -exec basename {} \; | fzf --prompt="Choose project to add the file ")

  if test (string length $tool || echo 0) -eq 0
    read -P 'New tool folder: ' tool
    if test -d $DOTSECRETS_DIR/$tool
      echo "Folder for tool $tool already exists"
      return 1
    end
  end

  set destination (string replace $HOME $DOTSECRETS_DIR/$tool $file)

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
  pushd $DOTSECRETS_DIR > /dev/null
  stow -t ~ -R "$tool"
  popd > /dev/null 2>&1
end
complete -xc dotsecrets -n __fish_use_subcommand -a add -d "add and stow new file to dotsecrets"

# install subcommand
function _dotsecrets_install
  pushd $DOTSECRETS_DIR > /dev/null
  make install
  popd > /dev/null 2>&1
end
complete -xc dotsecrets -n __fish_use_subcommand -a install -d "[re]install dotsecrets"

# update subcommand
function _dotsecrets_update
  pushd $DOTSECRETS_DIR > /dev/null
  git pull
  make install
  popd > /dev/null 2>&1
end
complete -xc dotsecrets -n __fish_use_subcommand -a update -d "update dotsecrets"

# setup subcommand
function _dotsecrets_setup
  pushd $DOTSECRETS_DIR > /dev/null
  make setup
  popd > /dev/null 2>&1
end
complete -xc dotsecrets -n __fish_use_subcommand -a setup -d "setup environment for dotsecrets"

# code subcommand
function _dotsecrets_code
  code $DOTSECRETS_DIR
end
complete -xc dotsecrets -n __fish_use_subcommand -a code -d "open VSCode on dotsecrets' repository"

# lg subcommand
function _dotsecrets_lg
  pushd $DOTSECRETS_DIR > /dev/null
  lazygit
  popd > /dev/null 2>&1
end
complete -xc dotsecrets -n __fish_use_subcommand -a lg -d "open lazygit at dotsecrets repository"
