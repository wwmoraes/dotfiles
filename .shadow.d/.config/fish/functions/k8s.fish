function k8s -a cmd -d "utilities for Kubernetes management"
  switch "$cmd"
  # TODO create kubectl plugin
  case "finalize-namespace"
    set -l NAMESPACE (kubectl get namespaces \
      | fzf --ansi --header-lines=1 \
      | awk '{print $1}')

    set -l PATCH_FILE (mktemp)
    kubectl get namespace $NAMESPACE -o json | jq '.spec.finalizers = []' > $PATCH_FILE

    kubectl proxy &
    set -l pid $last_pid
    sleep 1

    curl -k -H "Content-Type: application/json" -X PUT --data-binary @$PATCH_FILE 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize || true
    kill $sudo_pid 2> /dev/null

    rm -f $PATCH_FILE
  end
end

complete -xc k8s -n __fish_use_subcommand -a finalize-namespace -d "removes a rogue namespace forcefully"
