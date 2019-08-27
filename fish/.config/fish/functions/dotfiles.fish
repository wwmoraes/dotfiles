function dotfiles -a cmd -d "Setup dotfiles"
  switch "$cmd"
    case install
      _dotfiles_install
    case push
      _dotfiles_push
    case pull
      _dotfiles_pull
    case status
      _dotfiles_status
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec dotfiles

function _dotfiles_install
  pushd ~/.dotfiles > /dev/null
  make install
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a install -d "[re]install dotfiles"

function _dotfiles_push
  pushd ~/.dotfiles > /dev/null
  git push
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a push -d "push dotfiles"

function _dotfiles_pull
  pushd ~/.dotfiles > /dev/null
  git pull
  popd > /dev/null
end
complete -xc dotfiles -n __fish_use_subcommand -a pull -d "pull dotfiles"

function _dotfiles_status
  git -C ~/.dotfiles status -s
end
complete -xc dotfiles -n __fish_use_subcommand -a status -d "check dotfiles repository status"