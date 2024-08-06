function dockr -w docker -a cmd -d "Docker CLI wrapper with extra commands"
  command -q docker; or echo "docker is not installed" && return
  command -q fzf; or echo "fzf is not installed" && return

  switch "$cmd"
  case context
    set -l tag (echo $PWD | md5sum | cut -d' ' -f1)
    printf '\
    FROM scratch
    WORKDIR /context
    COPY . .
    ' | docker build --load -q -f - -t $tag . > /dev/null

    docker create --name $tag $tag /bin/true > /dev/null
    docker export $tag | tar -tf - 'context/*' | sed 's|^context/||g' | grep --color=never .
    docker container rm $tag > /dev/null
    docker image rm $tag > /dev/null
  case fsbom
      docker image ls | awk '$1 != "<none>" && $2 != "<none>"' | fzf --header-lines=1 -0 | awk '{print $1":"$2}' | ifne xargs -o -I{} syft $argv[2..-1] {}
  case fexec
    docker container ls | tail -n +2 | fzf -m -0 | awk '{print $1}' | ifne xargs -o -I{} -n 1 docker exec -it {} $argv[2..-1]
  case fscan
    docker image ls | awk '$1 != "<none>" && $2 != "<none>"' | fzf --header-lines=1 -0 | awk '{print $1":"$2}' | ifne xargs -o -I{} grype $argv[2..-1] {}
  case labels
    set -l images (docker image ls | awk '$1 != "<none>" && $2 != "<none>"' | fzf -m --header-lines=1 -0 | awk '{print $1":"$2}')
    if test (count $images)
      for image in $images
        printf "Image: $image\n\n"

        ### docker CLI has some serious problems with shell scripting: a plain
        ### inspect call with the -f flag works, e.g.:
        # docker inspect -f '{{range $k, $v := .Config.Labels}}{{printf "%s=%s\n" $k $v}}{{end}}' $image
        ### however, if you try the very same command on a pipe or within a
        ### subshell (e.g. to store in a variable), it errors with
        ### '"docker inspect" requires at least 1 argument.', which is
        ### absolutely bs. E.g.:
        # docker inspect -f '{{range $k, $v := .Config.Labels}}{{printf "%s=%s\n" $k $v}}{{end}}' $image \
        # | cat (echo "LABEL=VALUE" | psub) - | column -t -s =
        ### OR
        # set labels (docker inspect -f '{{range $k, $v := .Config.Labels}}{{printf "%s=%s\n" $k $v}}{{end}}' $image)
        ### Both examples error for no good reason.
        ### So back to jq it is then, which is far more stable...
        docker inspect $image \
        | jq -r '.[0].Config.Labels | to_entries | map("\\(.key)=\\(.value)") | .[]' \
        | cat (echo "LABEL=VALUE" | psub) - | column -t -s =

        echo
      end
    end
  case reclaim
    docker run --privileged --pid=host justincormack/nsenter1 /sbin/fstrim /var/lib/docker
    case stop
    docker ps | fzf -m --header-lines=1 -0 | awk 'ORS=" " {print $1}' | ifne xargs -n 1 docker stop
  case rmc
    docker container ls -a | tail -n +2 | fzf -m -0 | awk '{print $1}' | ifne xargs -I{} -n 1 docker container rm $argv[2..-1] {}
  case rmi
    docker image ls | tail -n +2 | fzf -m -0 | awk '$1 == "<none>" || $2 == "<none>" {print $3;next};{print $1":"$2}' | ifne xargs docker rmi $argv[2..-1]
  case rmin
    set -l images (docker images | awk '/^<none>[ ]+<none>/ {print $3}')
    if test (count $images) -gt 0
      docker rmi $images
    else
      echo "there's no <none>:<none> images to remove"
    end
  case rmv
    docker volume ls | tail -n +2 | fzf -m -0 | awk '{print $2}' | ifne xargs -n 1 docker volume rm
  case shell
    switch (uname -s | tr '[:upper:]' '[:lower:]')
    case "darwin" "windows"
      # docker run -it --rm --privileged --pid=host justincormack/nsenter1
      test (count $argv[2..-1]) -eq 0 && set -a argv sh
      docker run -it --privileged --pid=host busybox nsenter -t 1 -m -u -n -i $argv[2..-1]
    case "linux"
      echo "Linux doesn't have a separate VM for Docker."
      exit 0
    case "" "*"
      echo "Unknown system type."
      exit 1
    end
  case tags
    for image in $argv[2..-1]
      set -l tags (curl -fsSL https://registry.hub.docker.com/v1/repositories/$image/tags | jq -r '.[].name' | xargs)
      printf "%s: %s\n" $image $tags
    end
  case "*"
    docker $argv
  end
end
