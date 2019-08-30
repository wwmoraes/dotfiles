# secrets main command
function secrets -a cmd -d "Setup secrets"
  switch "$cmd"
    case install
      _secrets_install
    case update
      _secrets_update
    case code
      _secrets_code
    case lg
      _secrets_lg
    case status
      _secrets_status
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

# update subcommand
function _secrets_update
  pushd ~/.secrets > /dev/null
  git pull
  popd > /dev/null
end
complete -xc secrets -n __fish_use_subcommand -a update -d "get latest version of secrets"

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

# status subcommand
function _secrets_status
  git -C ~/.secrets status -s
end
complete -xc secrets -n __fish_use_subcommand -a status -d "check secrets repository status"