function dockr -a cmd -d "Docker CLI wrapper with extra commands"
  type -q docker; or echo "docker is not installed" && return
  type -q awk; or echo "awk is not installed" && return
  type -q tail; or echo "tail is not installed" && return
  type -q fzf; or echo "fzf is not installed" && return
  type -q xargs; or echo "xargs is not installed" && return

  switch "$cmd"
  case rmin
    set -l images (docker images | awk '/^<none>[ ]+<none>/ {print $3}')
    if test (count $images) -gt 0
      docker rmi (docker images | awk '/^<none>[ ]+<none>/ {print $3}')
    else
      echo "there's no <none>:<none> images to remove"
    end
  case rmc
    docker container ls -a | tail +2 | fzf -m -0 | awk '{print $1}' | xargs docker container rm
  case rmi
    docker image ls | tail +2 | fzf -m -0 | awk '{print $3}' | xargs docker image rm $argv[2..-1]
  case rmv
    docker volume ls | tail +2 | fzf -m -0 | awk '{print $2}' | xargs docker volume rm
  # case ""
  #   __fish_print_help dockr
  case "*"
    docker $argv
  end
end

complete -ec dockr
complete -c dockr -w docker
complete -xc dockr -n __fish_use_subcommand -a rmin -d "removes all anonymous images (no repo and no tag/<none>:<none>)"
complete -xc dockr -n __fish_use_subcommand -a rmi -d "remove images interactively"
complete -xc dockr -n __fish_use_subcommand -a rmc -d "remove containers interactively"
complete -xc dockr -n __fish_use_subcommand -a rmv -d "remove volumes interactively"
