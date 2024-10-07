# only apply on interactive shells
status --is-interactive; or exit

abbr -a .f chezmoi
abbr -a .fa "chezmoi apply"
abbr -a .fc "chezmoi check"
abbr -a .fe "chezmoi env"
abbr -a .fi "chezmoi init"
abbr -a .fl "chezmoi lg"
abbr -a .fr "chezmoi run"
abbr -a .fs "chezmoi sync"
abbr -a .fx "hx -w ~/.local/share/chezmoi"

abbr -a lg lazygit

if command -q git
  abbr -a g "git"
  abbr -a gc "git checkout"
  abbr -a ga "git add --all && git commit --amend --no-edit"
  abbr -a gp "git push"
  abbr -a gg "git push --force"
  abbr -a gs "git s -s"
  abbr -a gd "git d"
  abbr -a gr "git rebase --autosquash -i"
  abbr -a grr "git rebase --autosquash -i --root"
end

if command -q kubectl
  # base kubectl
  abbr -a k "kubectl"
  abbr -a kg "kubectl get"
  abbr -a kga "kubectl get all"
  abbr -a kge "kubectl get events"
  abbr -a kgaa "kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret"
  abbr -a kdelf "kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret | awk 'NF > 0 && \$1 != \"NAME\" {print \$1}' | fzf -0 -m --ansi | xargs -I{} -o kubectl delete {} --wait=false --now=true"
  abbr -a kgra "kubectl api-resources --verbs=list --namespaced -o name | grep -v events | xargs -n 1 kubectl get --show-kind --ignore-not-found"
  abbr -a krt "kubectl run --rm -it --image=wwmoraes/toolbox --restart=Never toolbox"
  abbr -a kl "kubectl logs"
  abbr -a kpf "kubectl port-forward"
  abbr -a kctx "kubectl ctx"
  abbr -a kns "kubectl ns"
  abbr -a ksh " kubectl iexec"
  abbr -a kosvc "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs kubectl open-svc"
  abbr -a kgextsvc "kubectl get services | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t"
  abbr -a kgaextsvc "kubectl get services -A | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t"
  abbr -a kgpol "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o  go-template='{{range \$name, \$value := .metadata.labels}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"
  abbr -a kgpoa "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o  go-template='{{range \$name, \$value := .metadata.annotations}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"
  abbr -a kgnol "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o  go-template='{{range \$name, \$value := .metadata.labels}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"
  abbr -a kgnoa "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o  go-template='{{range \$name, \$value := .metadata.annotations}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"

  # base kubectl (fuzzy)
  abbr -a klpof "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs {}"
  abbr -a kldf "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs deployment/{}"
  abbr -a kldsf "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs daemonset/{}"
  abbr -a klssf "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs statefulset/{}"
  abbr -a kpfpo "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward pod/{} 8080:80"
  abbr -a kpfsvc "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward service/{} 8080:80"
  abbr -a kpfing "kubectl get ingresses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward ingress.extensions/{} 8080:80"

  # k edit ...
  abbr -a kepo "kubectl edit pod"
  abbr -a keing "kubectl edit ingress"
  abbr -a kesvc "kubectl edit service"
  abbr -a kecm "kubectl edit configmap"
  abbr -a kes "kubectl edit secret"
  abbr -a keds "kubectl edit daemonset"
  abbr -a ked "kubectl edit deployment"
  abbr -a kepv "kubectl edit persistentvolume"
  abbr -a kepvc "kubectl edit persistentvolumeclaim"
  abbr -a kesa "kubectl edit serviceaccount"
  abbr -a kens "kubectl edit namespace"
  abbr -a keno "kubectl edit node"
  abbr -a kecrd "kubectl edit customresourcedefinition"
  abbr -a kests "kubectl edit statefulset"
  abbr -a kehpa "kubectl edit horizontalpodautoscaler"
  abbr -a kecj "kubectl edit cronjob"
  abbr -a kej "kubectl edit job"
  abbr -a kenetpol "kubectl edit networkpolicy"
  abbr -a ker "kubectl edit role"
  abbr -a kerb "kubectl edit rolebinding"
  abbr -a kecr "kubectl edit clusterrole"
  abbr -a kecrb "kubectl edit clusterrolebinding"
  abbr -a kesc "kubectl edit storageclass"
  abbr -a kers "kubectl edit replicaset"
  abbr -a keq "kubectl edit quota"

  # k edit ... (fuzzy)
  abbr -a kepof "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit pod {}"
  abbr -a keingf "kubectl get ingress | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit ingress {}"
  abbr -a kesvcf "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit service {}"
  abbr -a kecmf "kubectl get configmaps | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit configmap {}"
  abbr -a kesf "kubectl get secrets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit secret {}"
  abbr -a kedsf "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit daemonset {}"
  abbr -a kedf "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit deployment {}"
  abbr -a kepvf "kubectl get persistentvolumes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit persistentvolume {}"
  abbr -a kepvcf "kubectl get persistentvolumeclaims | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit persistentvolumeclaim {}"
  abbr -a kesaf "kubectl get serviceaccounts | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit serviceaccount {}"
  abbr -a kensf "kubectl get namespaces | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit namespace {}"
  abbr -a kenof "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit node {}"
  abbr -a kecrdf "kubectl get customresourcedefinitions | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit customresourcedefinition {}"
  abbr -a kestsf "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit statefulset {}"
  abbr -a kehpaf "kubectl get horizontalpodautoscalers | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit horizontalpodautoscaler {}"
  abbr -a kecjf "kubectl get cronjobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit cronjob {}"
  abbr -a kejf "kubectl get jobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit job {}"
  abbr -a kenetpolf "kubectl get networkpolicies | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit networkpolicy {}"
  abbr -a kerf "kubectl get roles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit role {}"
  abbr -a kerbf "kubectl get rolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit rolebinding {}"
  abbr -a kecrf "kubectl get clusterroles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit clusterrole {}"
  abbr -a kecrbf "kubectl get clusterrolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit clusterrolebinding {}"
  abbr -a kescf "kubectl get storageclasses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit storageclass {}"
  abbr -a kersf "kubectl get replicasets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit replicaset {}"
  abbr -a keendf "kubectl get endpoints | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit endpoint {}"

  # k get ...
  abbr -a kgpo "kubectl get pods"
  abbr -a kging "kubectl get ingresses"
  abbr -a kgsvc "kubectl get services"
  abbr -a kgcm "kubectl get configmaps"
  abbr -a kgs "kubectl get secrets"
  abbr -a kgds "kubectl get daemonsets"
  abbr -a kgd "kubectl get deployments"
  abbr -a kgpv "kubectl get persistentvolumes"
  abbr -a kgpvc "kubectl get persistentvolumeclaims"
  abbr -a kgsa "kubectl get serviceaccounts"
  abbr -a kgns "kubectl get namespaces"
  abbr -a kgno "kubectl get nodes"
  abbr -a kgcrd "kubectl get customresourcedefinitions"
  abbr -a kgsts "kubectl get statefulsets"
  abbr -a kghpa "kubectl get horizontalpodautoscalers"
  abbr -a kgcj "kubectl get cronjobs"
  abbr -a kgj "kubectl get jobs"
  abbr -a kgnetpol "kubectl get networkpolicies"
  abbr -a kgr "kubectl get roles"
  abbr -a kgrb "kubectl get rolebindings"
  abbr -a kgcr "kubectl get clusterroles"
  abbr -a kgcrb "kubectl get clusterrolebindings"
  abbr -a kgsc "kubectl get storageclasses"
  abbr -a kgrs "kubectl get replicasets"
  abbr -a kgend "kubectl get endpoints"
  abbr -a kglr "kubectl get limitranges"
  # k get ... (yaml)
  abbr -a kgpoy "kubectl get pods -o yaml"
  abbr -a kgingy "kubectl get ingresses -o yaml"
  abbr -a kgsvcy "kubectl get services -o yaml"
  abbr -a kgcmy "kubectl get configmaps -o yaml"
  abbr -a kgsy "kubectl get secrets -o yaml"
  abbr -a kgdsy "kubectl get daemonsets -o yaml"
  abbr -a kgdy "kubectl get deployments -o yaml"
  abbr -a kgpvy "kubectl get persistentvolumes -o yaml"
  abbr -a kgpvcy "kubectl get persistentvolumeclaims -o yaml"
  abbr -a kgsay "kubectl get serviceaccounts -o yaml"
  abbr -a kgnsy "kubectl get namespaces -o yaml"
  abbr -a kgnoy "kubectl get nodes -o yaml"
  abbr -a kgcrdy "kubectl get customresourcedefinitions -o yaml"
  abbr -a kgstsy "kubectl get statefulsets -o yaml"
  abbr -a kghpay "kubectl get horizontalpodautoscalers -o yaml"
  abbr -a kgcjy "kubectl get cronjobs -o yaml"
  abbr -a kgjy "kubectl get jobs -o yaml"
  abbr -a kgnetpoly "kubectl get networkpolicies -o yaml"
  abbr -a kgry "kubectl get roles -o yaml"
  abbr -a kgrby "kubectl get rolebindings -o yaml"
  abbr -a kgcry "kubectl get clusterroles -o yaml"
  abbr -a kgcrby "kubectl get clusterrolebindings -o yaml"
  abbr -a kgscy "kubectl get storageclasses -o yaml"
  abbr -a kgrsy "kubectl get replicasets -o yaml"
  abbr -a kgendy "kubectl get endpoints -o yaml"
  abbr -a kgqy "kubectl get quotas -o yaml"
  abbr -a kglry "kubectl get limitranges -o yaml"
  # k get ... (yaml, fuzzy, neat)
  abbr -a kgpof "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o yaml | kubectl neat -f -"
  abbr -a kgingf "kubectl get ingress | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get ingress {} -o yaml | kubectl neat -f -"
  abbr -a kgsvcf "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get service {} -o yaml | kubectl neat -f -"
  abbr -a kgcmf "kubectl get configmaps | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get configmap {} -o yaml | kubectl neat -f -"
  abbr -a kgsf "kubectl get secrets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get secret {} -o yaml | kubectl neat -f -"
  abbr -a kgdsf "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get daemonset {} -o yaml | kubectl neat -f -"
  abbr -a kgdf "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get deployment {} -o yaml | kubectl neat -f -"
  abbr -a kgpvf "kubectl get persistentvolumes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get persistentvolume {} -o yaml | kubectl neat -f -"
  abbr -a kgpvcf "kubectl get persistentvolumeclaims | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get persistentvolumeclaim {} -o yaml | kubectl neat -f -"
  abbr -a kgsaf "kubectl get serviceaccounts | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get serviceaccount {} -o yaml | kubectl neat -f -"
  abbr -a kgnsf "kubectl get namespaces | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get namespace {} -o yaml | kubectl neat -f -"
  abbr -a kgnof "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o yaml | kubectl neat -f -"
  abbr -a kgcrdf "kubectl get customresourcedefinitions | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get customresourcedefinition {} -o yaml | kubectl neat -f -"
  abbr -a kgstsf "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get statefulset {} -o yaml | kubectl neat -f -"
  abbr -a kghpaf "kubectl get horizontalpodautoscalers | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get horizontalpodautoscaler {} -o yaml | kubectl neat -f -"
  abbr -a kgcjf "kubectl get cronjobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get cronjob {} -o yaml | kubectl neat -f -"
  abbr -a kgjf "kubectl get jobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get job {} -o yaml | kubectl neat -f -"
  abbr -a kgnetpolf "kubectl get networkpolicies | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get networkpolicy {} -o yaml | kubectl neat -f -"
  abbr -a kgrf "kubectl get roles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get role {} -o yaml | kubectl neat -f -"
  abbr -a kgrbf "kubectl get rolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get rolebinding {} -o yaml | kubectl neat -f -"
  abbr -a kgcrf "kubectl get clusterroles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get clusterrole {} -o yaml  | kubectl neat -f -"
  abbr -a kgcrbf "kubectl get clusterrolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get clusterrolebinding {} -o yaml | kubectl neat -f -"
  abbr -a kgscf "kubectl get storageclasses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get storageclass {} -o yaml | kubectl neat -f -"
  abbr -a kgrsf "kubectl get replicasets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get replicaset {} -o yaml | kubectl neat -f -"
  abbr -a kgendf "kubectl get endpoints | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get endpoints {} -o yaml | kubectl neat -f -"
  abbr -a kgqf "kubectl get quota | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get quota {} -o yaml | kubectl neat -f -"
  abbr -a kglrf "kubectl get limitrange | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get limitrange {} -o yaml | kubectl neat -f -"
  # k describe ... (non-fuzzy)
  abbr -a kdpo "kubectl describe pods"
  abbr -a kding "kubectl describe ingresses"
  abbr -a kdsvc "kubectl describe services"
  abbr -a kdcm "kubectl describe configmaps"
  abbr -a kds "kubectl describe secrets"
  abbr -a kdds "kubectl describe daemonsets"
  abbr -a kdd "kubectl describe deployments"
  abbr -a kdpv "kubectl describe persistentvolumes"
  abbr -a kdpvc "kubectl describe persistentvolumeclaims"
  abbr -a kdsa "kubectl describe serviceaccounts"
  abbr -a kdns "kubectl describe namespaces"
  abbr -a kdno "kubectl describe nodes"
  abbr -a kdcrd "kubectl describe customresourcedefinitions"
  abbr -a kdsts "kubectl describe statefulsets"
  abbr -a kdhpa "kubectl describe horizontalpodautoscalers"
  abbr -a kdcj "kubectl describe cronjobs"
  abbr -a kdj "kubectl describe jobs"
  abbr -a kdnetpol "kubectl describe networkpolicies"
  abbr -a kdr "kubectl describe roles"
  abbr -a kdrb "kubectl describe rolebindings"
  abbr -a kdcr "kubectl describe clusterroles"
  abbr -a kdcrb "kubectl describe clusterrolebindings"
  abbr -a kdsc "kubectl describe storageclasses"
  abbr -a kdrs "kubectl describe replicasets"
  abbr -a kdend "kubectl describe endpoints"
  # k describe ... (fuzzy)
  abbr -a kdpof "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe pod {}"
  abbr -a kdingf "kubectl get ingress | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe ingress {}"
  abbr -a kdsvcf "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe service {}"
  abbr -a kdcmf "kubectl get configmaps | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe configmap {}"
  abbr -a kdsf "kubectl get secrets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe secret {}"
  abbr -a kddsf "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe daemonset {}"
  abbr -a kddf "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe deployment {}"
  abbr -a kdpvf "kubectl get persistentvolumes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe persistentvolume {}"
  abbr -a kdpvcf "kubectl get persistentvolumeclaims | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe persistentvolumeclaim {}"
  abbr -a kdsaf "kubectl get serviceaccounts | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe serviceaccount {}"
  abbr -a kdnsf "kubectl get namespaces | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe namespace {}"
  abbr -a kdnof "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe node {}"
  abbr -a kdcrdf "kubectl get customresourcedefinitions | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe customresourcedefinition {}"
  abbr -a kdstsf "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe statefulset {}"
  abbr -a kdhpaf "kubectl get horizontalpodautoscalers | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe horizontalpodautoscaler {}"
  abbr -a kdcjf "kubectl get cronjobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe cronjob {}"
  abbr -a kdjf "kubectl get jobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe job {}"
  abbr -a kdnetpolf "kubectl get networkpolicies | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe networkpolicy {}"
  abbr -a kdrf "kubectl get roles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe role {}"
  abbr -a kdrbf "kubectl get rolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe rolebinding {}"
  abbr -a kdcrf "kubectl get clusterroles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe clusterrole {}"
  abbr -a kdcrbf "kubectl get clusterrolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe clusterrolebinding {}"
  abbr -a kdscf "kubectl get storageclasses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe storageclass {}"
  abbr -a kdrsf "kubectl get replicasets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe replicaset {}"
  abbr -a kdendf "kubectl get endpoints | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe endpoint {}"
  # k delete ... (fuzzy)
  abbr -a kdelpof "kubectl get pods | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete pod {} --wait=false --now=true"
  abbr -a kdelingf "kubectl get ingress | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete ingress {} --wait=false --now=true"
  abbr -a kdelsvcf "kubectl get services | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete service {} --wait=false --now=true"
  abbr -a kdelcmf "kubectl get configmaps | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete configmap {} --wait=false --now=true"
  abbr -a kdelsf "kubectl get secrets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete secret {} --wait=false --now=true"
  abbr -a kdeldsf "kubectl get daemonsets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete daemonset {} --wait=false --now=true"
  abbr -a kdeldf "kubectl get deployments | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete deployment {} --wait=false --now=true"
  abbr -a kdelpvf "kubectl get persistentvolumes | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete persistentvolume {} --wait=false --now=true"
  abbr -a kdelpvcf "kubectl get persistentvolumeclaims | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete persistentvolumeclaim {} --wait=false --now=true"
  abbr -a kdelsaf "kubectl get serviceaccounts | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete serviceaccount {} --wait=false --now=true"
  abbr -a kdelnsf "kubectl get namespaces | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete namespace {} --wait=false --now=true"
  abbr -a kdelnof "kubectl get nodes | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete node {} --wait=false --now=true"
  abbr -a kdelcrdf "kubectl get customresourcedefinitions | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete customresourcedefinition {} --wait=false --now=true"
  abbr -a kdelstsf "kubectl get statefulsets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete statefulset {} --wait=false --now=true"
  abbr -a kdelhpaf "kubectl get horizontalpodautoscalers | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete horizontalpodautoscaler {} --wait=false --now=true"
  abbr -a kdelcjf "kubectl get cronjobs | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete cronjob {} --wait=false --now=true"
  abbr -a kdeljf "kubectl get jobs | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete job {} --wait=false --now=true"
  abbr -a kdelnetpolf "kubectl get networkpolicies | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete networkpolicy {} --wait=false --now=true"
  abbr -a kdelrf "kubectl get roles | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete role {} --wait=false --now=true"
  abbr -a kdelrbf "kubectl get rolebindings | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete rolebinding {} --wait=false --now=true"
  abbr -a kdelrsf "kubectl get replicasets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete replicaset {} --wait=false --now=true"
  abbr -a kdelcrf "kubectl get clusterroles | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete clusterrole {} --wait=false --now=true"
  abbr -a kdelcrbf "kubectl get clusterrolebindings | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete clusterrolebinding {} --wait=false --now=true"
  abbr -a kdelscf "kubectl get storageclasses | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete storageclass {} --wait=false --now=true"
  abbr -a kdelendf "kubectl get replicasets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete replicaset {} --wait=false --now=true"

  # k get event -w  ... (fuzzy)
  abbr -a kgpoef "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get event -w --field-selector involvedObject.name={}"
  abbr -a kgsvcef "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get event -w --field-selector involvedObject.name={}"

  # k config ... (fuzzy)
  abbr -a kdelctx "kubectl config get-contexts | awk 'NR == 1 || \$1 == \"*\" {\$1=\"\";print;next};1' | column -t | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl config delete-context {}"
  abbr -a kdelclu "kubectl config get-clusters | fzf -0 -m --ansi --header-lines=1 | xargs -I{} -o kubectl config delete-cluster {}"

  # flux
  # abbr -a kfxs "kubectl get fluxconfigs -A -o go-template --template '{{ range \$config := .items }}{{ with \$config }}{{ .metadata.name }}: {{ .status.lastSyncedCommit }}{{ \"\r\n\" }}{{ end }}{{ end }}' | column -t"
end
