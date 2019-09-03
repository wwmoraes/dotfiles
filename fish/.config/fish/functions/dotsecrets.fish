# dotsecrets main command
function dotsecrets -a cmd -d "Setup dotsecrets"
  switch "$cmd"
    case install
      _dotsecrets_install
    case code
      _dotsecrets_code
    case lg
      _dotsecrets_lg
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec dotsecrets

# install subcommand
function _dotsecrets_install
  pushd ~/.dotsecrets > /dev/null
  make install
  popd > /dev/null
end
complete -xc dotsecrets -n __fish_use_subcommand -a install -d "[re]install dotsecrets"

# code subcommand
function _dotsecrets_code
  code ~/.dotsecrets
end
complete -xc dotsecrets -n __fish_use_subcommand -a code -d "open VSCode on dotsecrets' repository"

# lg subcommand
function _dotsecrets_lg
  pushd ~/.dotsecrets > /dev/null
  lazygit
  popd > /dev/null
end
complete -xc dotsecrets -n __fish_use_subcommand -a lg -d "open lazygit at dotsecrets repository"
