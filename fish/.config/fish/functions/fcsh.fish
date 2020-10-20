function fcsh -d "fuzzy container shell"
  set -l container ( \
    docker ps | \
    fzf --header-lines=1 --prompt="Which container to connect to? " | \
    ifne awk '{print $1}')
  set container (string trim $container)
  test -z "$container"; and return 2

  set -l shell ( \
    docker exec -it $container cat /etc/shells | \
    awk '$0 !~ "^#.*"' | \
    fzf -1 --header="SHELL" --prompt="Which prompt to use? ")
  set shell (string trim $shell)
  test -z "$shell"; and return 2

  echo connecting to container $container with shell $shell...
  docker exec -it $container $shell
end
