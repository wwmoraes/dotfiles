# Abbreviations available only in interactive shells
status --is-interactive; or exit

# work-only
tags contains work; or exit

if type -q kubectl
  function work-setup
    printf "Fixing kubectl contexts...\n"
    kubectl config get-contexts | \
      tail -n +2 | \
      awk '$1 ~ /\*/ {print $2};$1 !~ /\*/ {print $2,$1}' | \
      sed -E 's/gke_mb-([a-z0-9-]+)_.*_([a-z0-9]+) (.*)/\3 \1-\2/; s/gke_messagebird-live_[^_]*_([a-z0-9-]+) (.*)/\2 old-\1/' | \
      awk 'NF == 2' | \
      xargs -I % sh -c 'kubectl config rename-context %'
  printf "setting default namespace for contexts without a namespace...\n"
  kubectl config get-contexts | \
    tail +2 | \
    awk '$1 == "*" {$1=""};1' | \
    awk 'NF == 3 {print $1}' | \
    xargs -I % kubectl config set-context % --namespace=default
  end
end
