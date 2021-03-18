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
      docker rmi $images
    else
      echo "there's no <none>:<none> images to remove"
    end
  case stop
    docker ps | fzf -m --header-lines=1 -0 | awk 'ORS=" " {print $1}' | ifne xargs -n 1 docker stop
  case rmc
    docker container ls -a | tail +2 | fzf -m -0 | awk '{print $1}' | ifne xargs -I{} -n 1 docker container rm $argv[2..-1] {}
  case exec
    docker container ls | tail +2 | fzf -m -0 | awk '{print $1}' | ifne xargs -o -I{} -n 1 docker exec -it {} $argv[2..-1]
  case rmi
    docker image ls | tail +2 | fzf -m -0 | awk '$1 == "<none>" || $2 == "<none>" {print $3;next};{print $1":"$2}' | ifne xargs docker rmi $argv[2..-1]
  case rmv
    docker volume ls | tail +2 | fzf -m -0 | awk '{print $2}' | ifne xargs -n 1 docker volume rm
  case fsbom
    docker image ls | awk '$1 != "<none>" && $2 != "<none>"' | fzf --header-lines=1 -0 | awk '{print $1":"$2}' | ifne xargs -o -I{} syft $argv[2..-1] {}
  case fscan
    docker image ls | awk '$1 != "<none>" && $2 != "<none>"' | fzf --header-lines=1 -0 | awk '{print $1":"$2}' | ifne xargs -o -I{} grype $argv[2..-1] {}
  case labels
    set -l images (docker image ls | awk '$1 != "<none>" && $2 != "<none>"' | fzf -m --header-lines=1 -0 | awk '{print $1":"$2}')
    if test (count $images)
      for image in $images
        printf "Image: $image\n\n"
        docker inspect -f '{{range $k, $v := .Config.Labels}}{{printf "%s=%s\n" $k $v}}{{end}}' $image | cat (echo "LABEL=VALUE" | psub) - | column -t -s =
        echo
      end
    end
  # case ""
  #   __fish_print_help dockr
  case tags
    for image in $argv[2..-1]
      set -l tags (curl -fsSL https://registry.hub.docker.com/v1/repositories/$image/tags | jq -r '.[].name' | xargs)
      printf "%s: %s\n" $image $tags
    end
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
complete -xc dockr -n __fish_use_subcommand -a labels -d "list all labels set on an image"
complete -xc dockr -n __fish_use_subcommand -a tags -d "list all image remote tags"
complete -xc dockr -n __fish_use_subcommand -a fsbom -d "fuzzy runs syft to get an image's SBoM"
complete -xc dockr -n __fish_use_subcommand -a fscan -d "fuzzy runs grype to scan images"
