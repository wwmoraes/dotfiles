function thelm -a cmd -d "tillerless helm 🖤" -w helm
  switch "$cmd"
  case "delete" "install" "list" "upgrade" "reset" "rollback" "status" "upgrade"
    _helm_start
    helm $argv
    _helm_stop
  case "fdelete"
    _helm_start
    helm list | fzf -m --ansi --header-lines=1 | awk '{print $1}' | xargs helm delete
    _helm_stop
  case "" "*"
    helm $argv
  end
end

function _helm_start
  set -lx HELM_TILLER_PORT 44134
  set -lx HELM_TILLER_PROBE_PORT 44135
  set -lx HELM_TILLER_STORAGE configmap
  set -lx HELM_TILLER_LOGS true
  set -lx HELM_TILLER_LOGS_DIR /dev/null
  set -lx HELM_TILLER_HISTORY_MAX 20
  set -lx PROBE_LISTEN_FLAG "--probe-listen=127.0.0.1:$HELM_TILLER_PROBE_PORT"
  set -lx TILLER_NAMESPACE (kubectl config view --minify --output 'jsonpath={..namespace}')

  if test -z $TILLER_NAMESPACE
    set -lx TILLER_NAMESPACE default
  end

  tiller --help 2>&1 | grep probe-listen > /dev/null || set -lx PROBE_LISTEN_FLAG=""

  # Run tiller
  tiller \
    --storage=$HELM_TILLER_STORAGE \
    --listen=127.0.0.1:$HELM_TILLER_PORT \
    $PROBE_LISTEN_FLAG \
    --history-max=$HELM_TILLER_HISTORY_MAX \
    2> $HELM_TILLER_LOGS_DIR &

  # disown it so it doesn't show up as a background job
  disown (jobs -lp)
end

function _helm_stop
  # KEEL EET
  pkill -9 -f tiller 2>&1 > /dev/null
end

complete -xc thelm -n __fish_use_subcommand -a fdelete -d "fuzzy delete a release"
