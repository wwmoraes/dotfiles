function k8s -a cmd -d "utilities for Kubernetes management"
  switch "$cmd"
  # TODO create kubectl plugin
  case finalize-namespace
    set -l resource (kubectl get namespaces \
      | fzf --ansi --header-lines=1 \
      | awk '{print $1}')

    set -l patch_file (mktemp)
    kubectl get namespace $resource -o json | jq '.spec.finalizers = []' > $patch_file

    kubectl proxy &
    set -l pid $last_pid
    sleep 1

    curl -k -H "Content-Type: application/json" -X PUT --data-binary @$patch_file 127.0.0.1:8001/api/v1/namespaces/$resource/finalize || true
    kill $last_pid 2> /dev/null

    rm -f $patch_file
  end
end

complete -xc k8s -n __fish_use_subcommand -a finalize-namespace -d "removes a rogue namespace forcefully"
