# dotsecrets main command
function dotsecrets -a cmd -d "Setup dotsecrets"
  switch "$cmd"
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
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec dotsecrets

# install subcommand
function _dotsecrets_install
  pushd ~/.secrets > /dev/null
  make install
  popd > /dev/null
end
complete -xc dotsecrets -n __fish_use_subcommand -a install -d "[re]install dotsecrets"

# update subcommand
function _dotsecrets_update
  pushd ~/.secrets > /dev/null
  git pull
  make install
  popd > /dev/null
end
complete -xc dotsecrets -n __fish_use_subcommand -a update -d "update dotsecrets"

# setup subcommand
function _dotsecrets_setup
  pushd ~/.secrets > /dev/null
  bash ./setup.sh
  popd > /dev/null
end
complete -xc dotsecrets -n __fish_use_subcommand -a setup -d "setup environment for dotsecrets"

# code subcommand
function _dotsecrets_code
  code ~/.secrets
end
complete -xc dotsecrets -n __fish_use_subcommand -a code -d "open VSCode on dotsecrets' repository"

# lg subcommand
function _dotsecrets_lg
  pushd ~/.secrets > /dev/null
  lazygit
  popd > /dev/null
end
complete -xc dotsecrets -n __fish_use_subcommand -a lg -d "open lazygit at dotsecrets repository"
