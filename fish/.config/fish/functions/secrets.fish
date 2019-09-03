# secrets main command
function secrets -a cmd -d "Setup secrets"
  switch "$cmd"
    case install
      _secrets_install
    case code
      _secrets_code
    case lg
      _secrets_lg
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec secrets

# install subcommand
function _secrets_install
  pushd ~/.secrets > /dev/null
  make install
  popd > /dev/null
end
complete -xc secrets -n __fish_use_subcommand -a install -d "[re]install secrets"

# code subcommand
function _secrets_code
  code ~/.secrets
end
complete -xc secrets -n __fish_use_subcommand -a code -d "open VSCode on secrets' repository"

# lg subcommand
function _secrets_lg
  pushd ~/.secrets > /dev/null
  lazygit
  popd > /dev/null
end
complete -xc secrets -n __fish_use_subcommand -a lg -d "open lazygit at secrets repository"
