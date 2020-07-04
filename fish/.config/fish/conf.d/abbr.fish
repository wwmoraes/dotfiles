# Abbreviations available only in interactive shells
status --is-interactive; or exit

abbr -a -g wttr "curl v2.wttr.in"

# git abbreviations
if type -q git
  abbr -a -g gco "git checkout"
  abbr -a -g gg "git push --force"
end

# kubectl abbreviations
if type -q kubectl
  # base kubectl
  abbr -a -g k "kubectl"
  abbr -a -g kg "kubectl get"
  abbr -a -g kga "kubectl get all"
  abbr -a -g kge "kubectl get events"
  abbr -a -g kgaa "kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret"
  abbr -a -g kdelf "kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret | awk 'NF > 0 && \$1 != \"NAME\" {print \$1}' | fzf -m --ansi | xargs -I{} kubectl delete {} --wait=false --now=true"
  abbr -a -g kgra "kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found"
  abbr -a -g krt "kubectl run toolbox -i --tty --rm --restart=Never --image=wwmoraes/toolbox"
  abbr -a -g kl "kubectl logs"
  abbr -a -g kpf "kubectl port-forward"
  abbr -a -g kctx "kubectl ctx"
  abbr -a -g kns "kubectl ns"
  abbr -a -g ksh "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I% bash -c '</dev/tty kubectl iexec %'"
  abbr -a -g kosvc "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs kubectl open-svc"
  abbr -a -g kgextsvc "kubectl get services | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t"
  abbr -a -g kgaextsvc "kubectl get services -A | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t"

  # base kubectl (fuzzy)
  abbr -a -g klpof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl logs {}"
  abbr -a -g kldf "kubectl get deployments | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl logs deployment/{}"
  abbr -a -g kpfpo "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl port-forward pod/{} 8080:80"
  abbr -a -g kpfsvc "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl port-forward service/{} 8080:80"
  abbr -a -g kpfing "kubectl get ingresses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl port-forward ingress.extensions/{} 8080:80"

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
  abbr -a -g kgrs "kubectl get replicasets"
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
  abbr -a -g kgrsy "kubectl get replicasets -o yaml"
  # k get ... (yaml, fuzzy, neat)
  abbr -a -g kgpof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat pod {} -o yaml"
  abbr -a -g kgingf "kubectl get ingress | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat ingress {} -o yaml"
  abbr -a -g kgsvcf "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat service {} -o yaml"
  abbr -a -g kgcmf "kubectl get configmaps | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl get configmap {} -o yaml"
  abbr -a -g kgsf "kubectl get secrets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl get secret {} -o yaml"
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
  abbr -a -g kgcrf "kubectl get clusterroles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl get clusterrole {} -o yaml"
  abbr -a -g kgcrbf "kubectl get clusterrolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl get clusterrolebinding {} -o yaml"
  abbr -a -g kgscf "kubectl get storageclasses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat storageclass {} -o yaml"
  abbr -a -g kgrsf "kubectl get replicasets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl neat replicaset {} -o yaml"
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
  abbr -a -g kdrs "kubectl describe replicasets"
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
  abbr -a -g kdrsf "kubectl get replicasets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl describe replicaset {}"
  # k delete ... (fuzzy)
  abbr -a -g kdelpof "kubectl get pods | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete pod {}"
  abbr -a -g kdelingf "kubectl get ingress | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete ingress {}"
  abbr -a -g kdelsvcf "kubectl get services | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete service {}"
  abbr -a -g kdelcmf "kubectl get configmaps | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete configmap {}"
  abbr -a -g kdelsf "kubectl get secrets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete secret {}"
  abbr -a -g kdeldsf "kubectl get daemonsets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete daemonset {}"
  abbr -a -g kdeldf "kubectl get deployments | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete deployment {}"
  abbr -a -g kdelpvf "kubectl get persistentvolumes | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete persistentvolume {}"
  abbr -a -g kdelpvcf "kubectl get persistentvolumeclaims | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete persistentvolumeclaim {}"
  abbr -a -g kdelsaf "kubectl get serviceaccounts | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete serviceaccount {}"
  abbr -a -g kdelnsf "kubectl get namespaces | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete namespace {} --wait=false --now=true"
  abbr -a -g kdelnof "kubectl get nodes | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete node {}"
  abbr -a -g kdelcrdf "kubectl get customresourcedefinitions | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete customresourcedefinition {}"
  abbr -a -g kdelstsf "kubectl get statefulsets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete statefulset {}"
  abbr -a -g kdelhpaf "kubectl get horizontalpodautoscalers | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete horizontalpodautoscaler {}"
  abbr -a -g kdelcjf "kubectl get cronjobs | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete cronjob {}"
  abbr -a -g kdeljf "kubectl get jobs | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete job {}"
  abbr -a -g kdelnetpolf "kubectl get networkpolicies | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete networkpolicy {}"
  abbr -a -g kdelrf "kubectl get roles | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete role {}"
  abbr -a -g kdelrbf "kubectl get rolebindings | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete rolebinding {}"
  abbr -a -g kdelcrf "kubectl get clusterroles | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete clusterrole {}"
  abbr -a -g kdelcrbf "kubectl get clusterrolebindings | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete clusterrolebinding {}"
  abbr -a -g kdelscf "kubectl get storageclasses | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete storageclass {}"
  abbr -a -g kdelrsf "kubectl get replicasets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl delete replicaset {}"

  # k get event -w  ... (fuzzy)
  abbr -a -g kgpoef "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl get event -w --field-selector involvedObject.name={}"
  abbr -a -g kgsvcef "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl get event -w --field-selector involvedObject.name={}"

  # k config ... (fuzzy)
  abbr -a -g kdelctx "kubectl config get-contexts | awk 'NR == 1 || \$1 == \"*\" {\$1=\"\";print;next};1' | column -t | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} kubectl config delete-context {}"
  abbr -a -g kdelclu "kubectl config get-clusters | fzf -m --ansi --header-lines=1 | xargs -I{} kubectl config delete-cluster {}"

  # work-only abbreviations
  if isWork
    abbr -a -g kdip "kubectl get secrets | awk 'NR==1{print;next};\$2 ~ /kubernetes.io\/dockerconfigjson/ {print}' | fzf --ansi --header-lines=1 -1 | awk '{print \$1}' | xargs -I{} kubectl get secret {} -o yaml | yq -r '.data[\".dockerconfigjson\"]' | base64 -D | jq -r '.auths | keys[] as \$key | .[\$key].auth' | base64 -D"

    abbr -a -g kinpri-backends "kubectl ingress-nginx -n nginx-private backends --deployment nginx-private-nginx-ingress-controller"
    abbr -a -g kinpub-backends "kubectl ingress-nginx -n nginx-public backends --deployment nginx-public-nginx-ingress-controller"
    abbr -a -g kinint-backends "kubectl ingress-nginx -n nginx-internal backends --deployment nginx-internal-nginx-ingress-controller"

    abbr -a -g kinpri-certs "kubectl get ingresses -A | awk '{print $1,$2,$3}' | column -t | fzf --header-lines=1 | awk '{print $3}' | tr ',' '\n' | fzf --header='HOST' -1 -0 | xargs kubectl ingress-nginx -n nginx-private certs --deployment nginx-private-nginx-ingress-controller --host"
    abbr -a -g kinpub-certs "kubectl get ingresses -A | awk '{print $1,$2,$3}' | column -t | fzf --header-lines=1 | awk '{print $3}' | tr ',' '\n' | fzf --header='HOST' -1 -0 | xargs kubectl ingress-nginx -n nginx-public certs --deployment nginx-public-nginx-ingress-controller --host"
    abbr -a -g kinint-certs "kubectl get ingresses -A | awk '{print $1,$2,$3}' | column -t | fzf --header-lines=1 | awk '{print $3}' | tr ',' '\n' | fzf --header='HOST' -1 -0 | xargs kubectl ingress-nginx -n nginx-internal certs --deployment nginx-internal-nginx-ingress-controller --host"

    abbr -a -g kinpri-conf "kubectl ingress-nginx -n nginx-private conf --deployment nginx-private-nginx-ingress-controller"
    abbr -a -g kinpub-conf "kubectl ingress-nginx -n nginx-public conf --deployment nginx-public-nginx-ingress-controller"
    abbr -a -g kinint-conf "kubectl ingress-nginx -n nginx-internal conf --deployment nginx-internal-nginx-ingress-controller"

    abbr -a -g "kinpri-exec" "kubectl ingress-nginx -n nginx-private exec --deployment nginx-private-nginx-ingress-controller"
    abbr -a -g "kinpub-exec" "kubectl ingress-nginx -n nginx-public exec --deployment nginx-public-nginx-ingress-controller"
    abbr -a -g "kinint-exec" "kubectl ingress-nginx -n nginx-internal exec --deployment nginx-internal-nginx-ingress-controller"

    abbr -a -g kinpri-general "kubectl ingress-nginx -n nginx-private general --deployment nginx-private-nginx-ingress-controller"
    abbr -a -g kinpub-general "kubectl ingress-nginx -n nginx-public general --deployment nginx-public-nginx-ingress-controller"
    abbr -a -g kinint-general "kubectl ingress-nginx -n nginx-internal general --deployment nginx-internal-nginx-ingress-controller"

    abbr -a -g kinpri-info "kubectl ingress-nginx -n nginx-private info --service nginx-private-nginx-ingress-controller"
    abbr -a -g kinpub-info "kubectl ingress-nginx -n nginx-public info --service nginx-public-nginx-ingress-controller"
    abbr -a -g kinint-info "kubectl ingress-nginx -n nginx-internal info --service nginx-internal-nginx-ingress-controller"

    # TODO ingresses

    # TODO lint

    abbr -a -g kinpri-logs "kubectl ingress-nginx -n nginx-private logs --deployment nginx-private-nginx-ingress-controller"
    abbr -a -g kinpub-logs "kubectl ingress-nginx -n nginx-public logs --deployment nginx-public-nginx-ingress-controller"
    abbr -a -g kinint-logs "kubectl ingress-nginx -n nginx-internal logs --deployment nginx-internal-nginx-ingress-controller"

    abbr -a -g kinpri-ssh "kubectl ingress-nginx -n nginx-private ssh --deployment nginx-private-nginx-ingress-controller"
    abbr -a -g kinpub-ssh "kubectl ingress-nginx -n nginx-public ssh --deployment nginx-public-nginx-ingress-controller"
    abbr -a -g kinint-ssh "kubectl ingress-nginx -n nginx-internal ssh --deployment nginx-internal-nginx-ingress-controller"
  end
end
