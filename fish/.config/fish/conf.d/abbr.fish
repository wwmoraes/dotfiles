# Abbreviations available only in interactive shells
if status --is-interactive
  # git abbreviations
  if type -q git
    abbr -a -g gco "git checkout"
  end

  # kubectl abbreviations
  if type -q kubectl
    # base kubectl
    abbr -a -g k "kubectl"
    abbr -a -g kga "kubectl get all"
    abbr -a -g kl "kubectl logs"
    abbr -a -g kpf "kubectl port-forward"
    abbr -a -g ksh "kubectl iexec (kubectl get pods | fzf --ansi --header-lines=1 | awk '{print $1}')"
    abbr -a -g kosvc "kubectl get services | fzf --ansi --header-lines=1 | awk '{print $1}' | xargs kubectl open-svc"
    # base kubectl (fuzzy)
    abbr -a -g klf "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl logs {}"
    abbr -a -g kpfpo "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl port-forward pod/{} 8080:80"
    abbr -a -g kpfsvc "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl port-forward service/{} 8080:80"
    abbr -a -g kpfing "kubectl get ingresses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl port-forward ingress/{} 8080:80"
    # k get ...
    abbr -a -g kgpo "kubectl get pods"
    abbr -a -g kging "kubectl get ingresses"
    abbr -a -g kgsvc "kubectl get services"
    abbr -a -g kgcm "kubectl get configmaps"
    abbr -a -g kgs "kubectl get secrets"
    abbr -a -g kgds "kubectl get daemonsets"
    abbr -a -g kgd "kubectl get deployments"
    abbr -a -g kgpv "kubectl get persistentvolumes"
    abbr -a -g kgpvc "kubectl get persistentvolumeclaims"
    abbr -a -g kgsa "kubectl get serviceaccounts"
    abbr -a -g kgns "kubectl get namespaces"
    abbr -a -g kgno "kubectl get nodes"
    abbr -a -g kgcrd "kubectl get customresourcedefinitions"
    abbr -a -g kgsts "kubectl get statefulsets"
    abbr -a -g kghpa "kubectl get horizontalpodautoscalers"
    abbr -a -g kgcj "kubectl get cronjobs"
    abbr -a -g kgj "kubectl get jobs"
    abbr -a -g kgnetpol "kubectl get networkpolicies"
    abbr -a -g kgr "kubectl get roles"
    abbr -a -g kgrb "kubectl get rolebindings"
    abbr -a -g kgcr "kubectl get clusterroles"
    abbr -a -g kgcrb "kubectl get clusterrolebindings"
    abbr -a -g kgsc "kubectl get storageclasses"
    # k get ... (yaml)
    abbr -a -g kgpoy "kubectl get pods -o yaml"
    abbr -a -g kgingy "kubectl get ingresses -o yaml"
    abbr -a -g kgsvcy "kubectl get services -o yaml"
    abbr -a -g kgcmy "kubectl get configmaps -o yaml"
    abbr -a -g kgsy "kubectl get secrets -o yaml"
    abbr -a -g kgdsy "kubectl get daemonsets -o yaml"
    abbr -a -g kgdy "kubectl get deployments -o yaml"
    abbr -a -g kgpvy "kubectl get persistentvolumes -o yaml"
    abbr -a -g kgpvcy "kubectl get persistentvolumeclaims -o yaml"
    abbr -a -g kgsay "kubectl get serviceaccounts -o yaml"
    abbr -a -g kgnsy "kubectl get namespaces -o yaml"
    abbr -a -g kgnoy "kubectl get nodes -o yaml"
    abbr -a -g kgcrdy "kubectl get customresourcedefinitions -o yaml"
    abbr -a -g kgstsy "kubectl get statefulsets -o yaml"
    abbr -a -g kghpay "kubectl get horizontalpodautoscalers -o yaml"
    abbr -a -g kgcjy "kubectl get cronjobs -o yaml"
    abbr -a -g kgjy "kubectl get jobs -o yaml"
    abbr -a -g kgnetpoly "kubectl get networkpolicies -o yaml"
    abbr -a -g kgry "kubectl get roles -o yaml"
    abbr -a -g kgrby "kubectl get rolebindings -o yaml"
    abbr -a -g kgcry "kubectl get clusterroles -o yaml"
    abbr -a -g kgcrby "kubectl get clusterrolebindings -o yaml"
    abbr -a -g kgscy "kubectl get storageclasses -o yaml"
    # k get ... (yaml, fuzzy, neat)
    abbr -a -g kgpof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat pod {} -o yaml"
    abbr -a -g kgingf "kubectl get ingress | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat ingress {} -o yaml"
    abbr -a -g kgsvcf "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat service {} -o yaml"
    abbr -a -g kgcmf "kubectl get configmaps | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat configmap {} -o yaml"
    abbr -a -g kgsf "kubectl get secrets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat secret {} -o yaml"
    abbr -a -g kgdsf "kubectl get daemonsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat daemonset {} -o yaml"
    abbr -a -g kgdf "kubectl get deployments | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat deployment {} -o yaml"
    abbr -a -g kgpvf "kubectl get persistentvolumes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat persistentvolume {} -o yaml"
    abbr -a -g kgpvcf "kubectl get persistentvolumeclaims | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat persistentvolumeclaim {} -o yaml"
    abbr -a -g kgsaf "kubectl get serviceaccounts | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat serviceaccount {} -o yaml"
    abbr -a -g kgnsf "kubectl get namespaces | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat namespace {} -o yaml"
    abbr -a -g kgnof "kubectl get nodes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat node {} -o yaml"
    abbr -a -g kgcrdf "kubectl get customresourcedefinitions | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat customresourcedefinition {} -o yaml"
    abbr -a -g kgstsf "kubectl get statefulsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat statefulset {} -o yaml"
    abbr -a -g kghpaf "kubectl get horizontalpodautoscalers | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat horizontalpodautoscaler {} -o yaml"
    abbr -a -g kgcjf "kubectl get cronjobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat cronjob {} -o yaml"
    abbr -a -g kgjf "kubectl get jobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat job {} -o yaml"
    abbr -a -g kgnetpolf "kubectl get networkpolicies | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat networkpolicy {} -o yaml"
    abbr -a -g kgrf "kubectl get roles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat role {} -o yaml"
    abbr -a -g kgrbf "kubectl get rolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat rolebinding {} -o yaml"
    abbr -a -g kgcrf "kubectl get clusterroles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat clusterrole {} -o yaml"
    abbr -a -g kgcrbf "kubectl get clusterrolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat clusterrolebinding {} -o yaml"
    abbr -a -g kgscf "kubectl get storageclasses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat storageclass {} -o yaml"
    # k describe ... (non-fuzzy)
    abbr -a -g kdpo "kubectl describe pods"
    abbr -a -g kding "kubectl describe ingresses"
    abbr -a -g kdsvc "kubectl describe services"
    abbr -a -g kdcm "kubectl describe configmaps"
    abbr -a -g kds "kubectl describe secrets"
    abbr -a -g kdds "kubectl describe daemonsets"
    abbr -a -g kdd "kubectl describe deployments"
    abbr -a -g kdpv "kubectl describe persistentvolumes"
    abbr -a -g kdpvc "kubectl describe persistentvolumeclaims"
    abbr -a -g kdsa "kubectl describe serviceaccounts"
    abbr -a -g kdns "kubectl describe namespaces"
    abbr -a -g kdno "kubectl describe nodes"
    abbr -a -g kdcrd "kubectl describe customresourcedefinitions"
    abbr -a -g kdsts "kubectl describe statefulsets"
    abbr -a -g kdhpa "kubectl describe horizontalpodautoscalers"
    abbr -a -g kdcj "kubectl describe cronjobs"
    abbr -a -g kdj "kubectl describe jobs"
    abbr -a -g kdnetpol "kubectl describe networkpolicies"
    abbr -a -g kdr "kubectl describe roles"
    abbr -a -g kdrb "kubectl describe rolebindings"
    abbr -a -g kdcr "kubectl describe clusterroles"
    abbr -a -g kdcrb "kubectl describe clusterrolebindings"
    abbr -a -g kdsc "kubectl describe storageclasses"
    # k describe ... (fuzzy)
    abbr -a -g kdpof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe pod {}"
    abbr -a -g kdingf "kubectl get ingress | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe ingress {}"
    abbr -a -g kdsvcf "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe service {}"
    abbr -a -g kdcmf "kubectl get configmaps | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe configmap {}"
    abbr -a -g kdsf "kubectl get secrets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe secret {}"
    abbr -a -g kddsf "kubectl get daemonsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe daemonset {}"
    abbr -a -g kddf "kubectl get deployments | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe deployment {}"
    abbr -a -g kdpvf "kubectl get persistentvolumes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe persistentvolume {}"
    abbr -a -g kdpvcf "kubectl get persistentvolumeclaims | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe persistentvolumeclaim {}"
    abbr -a -g kdsaf "kubectl get serviceaccounts | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe serviceaccount {}"
    abbr -a -g kdnsf "kubectl get namespaces | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe namespace {}"
    abbr -a -g kdnof "kubectl get nodes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe node {}"
    abbr -a -g kdcrdf "kubectl get customresourcedefinitions | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe customresourcedefinition {}"
    abbr -a -g kdstsf "kubectl get statefulsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe statefulset {}"
    abbr -a -g kdhpaf "kubectl get horizontalpodautoscalers | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe horizontalpodautoscaler {}"
    abbr -a -g kdcjf "kubectl get cronjobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe cronjob {}"
    abbr -a -g kdjf "kubectl get jobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe job {}"
    abbr -a -g kdnetpolf "kubectl get networkpolicies | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe networkpolicy {}"
    abbr -a -g kdrf "kubectl get roles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe role {}"
    abbr -a -g kdrbf "kubectl get rolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe rolebinding {}"
    abbr -a -g kdcrf "kubectl get clusterroles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe clusterrole {}"
    abbr -a -g kdcrbf "kubectl get clusterrolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe clusterrolebinding {}"
    abbr -a -g kdscf "kubectl get storageclasses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe storageclass {}"
  end
end
