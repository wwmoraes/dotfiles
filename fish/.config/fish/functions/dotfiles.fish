# dotfiles main command
function dotfiles -a cmd -d "Setup dotfiles"
  switch "$cmd"
    case install
      _dotfiles_install
    case setup
      _dotfiles_setup
    case update
      _dotfiles_update
    case code
      _dotfiles_code
    case lg
      _dotfiles_lg
    case status
      _dotfiles_status
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec dotfiles

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
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a setup -d "setup environment for dotfiles"

# update subcommand
function _dotfiles_update
  pushd ~/.dotfiles > /dev/null
  git pull
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a update -d "get latest version of dotfiles"

# code subcommand
function _dotfiles_code
  code ~/.dotfiles
end
complete -xc dotfiles -n __fish_use_subcommand -a code -d "open VSCode on dotfiles' repository"

# lg subcommand
function _dotfiles_lg
  pushd ~/.dotfiles > /dev/null
  lazygit
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a lg -d "open lazygit at dotfiles repository"

# status subcommand
function _dotfiles_status
  git -C ~/.dotfiles status -s
end
complete -xc dotfiles -n __fish_use_subcommand -a status -d "check dotfiles repository status"