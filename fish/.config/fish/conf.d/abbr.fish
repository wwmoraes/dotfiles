# only apply on interactive shells
status --is-interactive; or exit

### removes old abbreviations, but takes a bit of time
# abbr -l | xargs -P 8 -I % fish -c 'abbr -e -U %; true'

abbr -a -U wttr "curl v2.wttr.in"

# todo.sh
if type -q todo.sh
  abbr -a -U t "todo.sh"
  abbr -a -U tp "todo.sh p"
  abbr -a -U tpa "todo.sh p a"
  abbr -a -U tpls "todo.sh p ls"
end

# project fish command abbreviations
if type -q projects
  abbr -a -U pcd "projects cd"
  abbr -a -U pls "projects ls"
  abbr -a -U plg "projects lg"
  abbr -a -U pcode "projects code"
  abbr -a -U pnew "projects new"
  abbr -a -U pupdate "projects update"
end

# git abbreviations
if type -q git
  abbr -a -U g "git"
  abbr -a -U gc "git checkout"
  abbr -a -U ga "git add --all && git commit --amend --no-edit"
  abbr -a -U gp "git push"
  abbr -a -U gg "git push --force"
  abbr -a -U gs "git s -s"
  abbr -a -U gd "git d"
  abbr -a -U gr "git rebase --autosquash -i"
  abbr -a -U grr "git rebase --autosquash -i --root"
end

# terraform abbreviations
if type -q terraform
  abbr -a -U tf "terraform"
  abbr -a -U tfi "rm -rf .terraform && terraform init"
  abbr -a -U tfp "terraform plan -out=plan.tfplan"
  abbr -a -U tfa "terraform apply plan.tfplan"
  abbr -a -U tfip "rm -rf .terraform && terraform init && terraform plan -out=plan.tfplan"
end

# lab abbreviations
if type -q lab
  abbr -a -U glcv "gl ci view"
  abbr -a -U glcc "gl ci create"
  abbr -a -U glmc "gl mr create -d -s"
  abbr -a -U glma "gl mr approve"
  abbr -a -U glmm "gl mr merge"
  abbr -a -U glml "gl mr list"
end

# kubectl abbreviations
if type -q kubectl
  # base kubectl
  abbr -a -U k "kubectl"
  abbr -a -U kg "kubectl get"
  abbr -a -U kga "kubectl get all"
  abbr -a -U kge "kubectl get events"
  abbr -a -U kgaa "kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret"
  abbr -a -U kdelf "kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret | awk 'NF > 0 && \$1 != \"NAME\" {print \$1}' | fzf -m --ansi | xargs -I{} -o kubectl delete {} --wait=false --now=true"
  abbr -a -U kgra "kubectl api-resources --verbs=list --namespaced -o name | grep -v events | xargs -n 1 kubectl get --show-kind --ignore-not-found"
  abbr -a -U krt "kubectl run --rm -it --image=wwmoraes/toolbox --restart=Never toolbox"
  abbr -a -U kl "kubectl logs"
  abbr -a -U kpf "kubectl port-forward"
  abbr -a -U kctx "kubectl ctx"
  abbr -a -U kns "kubectl ns"
  abbr -a -U ksh "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -o -I% kubectl iexec %"
  abbr -a -U kosvc "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs kubectl open-svc"
  abbr -a -U kgextsvc "kubectl get services | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t"
  abbr -a -U kgaextsvc "kubectl get services -A | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t"
  abbr -a -U kgpol "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o  go-template='{{range \$name, \$value := .metadata.labels}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"
  abbr -a -U kgpoa "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o  go-template='{{range \$name, \$value := .metadata.annotations}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"
  abbr -a -U kgnol "kubectl get nodes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o  go-template='{{range \$name, \$value := .metadata.labels}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"
  abbr -a -U kgnoa "kubectl get nodes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o  go-template='{{range \$name, \$value := .metadata.annotations}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'"

  # base kubectl (fuzzy)
  abbr -a -U klpof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs {}"
  abbr -a -U kldf "kubectl get deployments | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs deployment/{}"
  abbr -a -U kldsf "kubectl get daemonsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs daemonset/{}"
  abbr -a -U klssf "kubectl get statefulsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs statefulset/{}"
  abbr -a -U kpfpo "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward pod/{} 8080:80"
  abbr -a -U kpfsvc "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward service/{} 8080:80"
  abbr -a -U kpfing "kubectl get ingresses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward ingress.extensions/{} 8080:80"

  # k edit ...
  abbr -a -U kepo "kubectl edit pod"
  abbr -a -U keing "kubectl edit ingress"
  abbr -a -U kesvc "kubectl edit service"
  abbr -a -U kecm "kubectl edit configmap"
  abbr -a -U kes "kubectl edit secret"
  abbr -a -U keds "kubectl edit daemonset"
  abbr -a -U ked "kubectl edit deployment"
  abbr -a -U kepv "kubectl edit persistentvolume"
  abbr -a -U kepvc "kubectl edit persistentvolumeclaim"
  abbr -a -U kesa "kubectl edit serviceaccount"
  abbr -a -U kens "kubectl edit namespace"
  abbr -a -U keno "kubectl edit node"
  abbr -a -U kecrd "kubectl edit customresourcedefinition"
  abbr -a -U kests "kubectl edit statefulset"
  abbr -a -U kehpa "kubectl edit horizontalpodautoscaler"
  abbr -a -U kecj "kubectl edit cronjob"
  abbr -a -U kej "kubectl edit job"
  abbr -a -U kenetpol "kubectl edit networkpolicy"
  abbr -a -U ker "kubectl edit role"
  abbr -a -U kerb "kubectl edit rolebinding"
  abbr -a -U kecr "kubectl edit clusterrole"
  abbr -a -U kecrb "kubectl edit clusterrolebinding"
  abbr -a -U kesc "kubectl edit storageclass"
  abbr -a -U kers "kubectl edit replicaset"
  abbr -a -U keq "kubectl edit quota"

  # k edit ... (fuzzy)
  abbr -a -U kepof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit pod {}"
  abbr -a -U keingf "kubectl get ingress | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit ingress {}"
  abbr -a -U kesvcf "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit service {}"
  abbr -a -U kecmf "kubectl get configmaps | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit configmap {}"
  abbr -a -U kesf "kubectl get secrets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit secret {}"
  abbr -a -U kedsf "kubectl get daemonsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit daemonset {}"
  abbr -a -U kedf "kubectl get deployments | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit deployment {}"
  abbr -a -U kepvf "kubectl get persistentvolumes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit persistentvolume {}"
  abbr -a -U kepvcf "kubectl get persistentvolumeclaims | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit persistentvolumeclaim {}"
  abbr -a -U kesaf "kubectl get serviceaccounts | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit serviceaccount {}"
  abbr -a -U kensf "kubectl get namespaces | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit namespace {}"
  abbr -a -U kenof "kubectl get nodes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit node {}"
  abbr -a -U kecrdf "kubectl get customresourcedefinitions | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit customresourcedefinition {}"
  abbr -a -U kestsf "kubectl get statefulsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit statefulset {}"
  abbr -a -U kehpaf "kubectl get horizontalpodautoscalers | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit horizontalpodautoscaler {}"
  abbr -a -U kecjf "kubectl get cronjobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit cronjob {}"
  abbr -a -U kejf "kubectl get jobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit job {}"
  abbr -a -U kenetpolf "kubectl get networkpolicies | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit networkpolicy {}"
  abbr -a -U kerf "kubectl get roles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit role {}"
  abbr -a -U kerbf "kubectl get rolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit rolebinding {}"
  abbr -a -U kecrf "kubectl get clusterroles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit clusterrole {}"
  abbr -a -U kecrbf "kubectl get clusterrolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit clusterrolebinding {}"
  abbr -a -U kescf "kubectl get storageclasses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit storageclass {}"
  abbr -a -U kersf "kubectl get replicasets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit replicaset {}"
  abbr -a -U keendf "kubectl get endpoints | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit endpoint {}"

  # k get ...
  abbr -a -U kgpo "kubectl get pods"
  abbr -a -U kging "kubectl get ingresses"
  abbr -a -U kgsvc "kubectl get services"
  abbr -a -U kgcm "kubectl get configmaps"
  abbr -a -U kgs "kubectl get secrets"
  abbr -a -U kgds "kubectl get daemonsets"
  abbr -a -U kgd "kubectl get deployments"
  abbr -a -U kgpv "kubectl get persistentvolumes"
  abbr -a -U kgpvc "kubectl get persistentvolumeclaims"
  abbr -a -U kgsa "kubectl get serviceaccounts"
  abbr -a -U kgns "kubectl get namespaces"
  abbr -a -U kgno "kubectl get nodes"
  abbr -a -U kgcrd "kubectl get customresourcedefinitions"
  abbr -a -U kgsts "kubectl get statefulsets"
  abbr -a -U kghpa "kubectl get horizontalpodautoscalers"
  abbr -a -U kgcj "kubectl get cronjobs"
  abbr -a -U kgj "kubectl get jobs"
  abbr -a -U kgnetpol "kubectl get networkpolicies"
  abbr -a -U kgr "kubectl get roles"
  abbr -a -U kgrb "kubectl get rolebindings"
  abbr -a -U kgcr "kubectl get clusterroles"
  abbr -a -U kgcrb "kubectl get clusterrolebindings"
  abbr -a -U kgsc "kubectl get storageclasses"
  abbr -a -U kgrs "kubectl get replicasets"
  abbr -a -U kgend "kubectl get endpoints"
  abbr -a -U kglr "kubectl get limitranges"
  # k get ... (yaml)
  abbr -a -U kgpoy "kubectl get pods -o yaml"
  abbr -a -U kgingy "kubectl get ingresses -o yaml"
  abbr -a -U kgsvcy "kubectl get services -o yaml"
  abbr -a -U kgcmy "kubectl get configmaps -o yaml"
  abbr -a -U kgsy "kubectl get secrets -o yaml"
  abbr -a -U kgdsy "kubectl get daemonsets -o yaml"
  abbr -a -U kgdy "kubectl get deployments -o yaml"
  abbr -a -U kgpvy "kubectl get persistentvolumes -o yaml"
  abbr -a -U kgpvcy "kubectl get persistentvolumeclaims -o yaml"
  abbr -a -U kgsay "kubectl get serviceaccounts -o yaml"
  abbr -a -U kgnsy "kubectl get namespaces -o yaml"
  abbr -a -U kgnoy "kubectl get nodes -o yaml"
  abbr -a -U kgcrdy "kubectl get customresourcedefinitions -o yaml"
  abbr -a -U kgstsy "kubectl get statefulsets -o yaml"
  abbr -a -U kghpay "kubectl get horizontalpodautoscalers -o yaml"
  abbr -a -U kgcjy "kubectl get cronjobs -o yaml"
  abbr -a -U kgjy "kubectl get jobs -o yaml"
  abbr -a -U kgnetpoly "kubectl get networkpolicies -o yaml"
  abbr -a -U kgry "kubectl get roles -o yaml"
  abbr -a -U kgrby "kubectl get rolebindings -o yaml"
  abbr -a -U kgcry "kubectl get clusterroles -o yaml"
  abbr -a -U kgcrby "kubectl get clusterrolebindings -o yaml"
  abbr -a -U kgscy "kubectl get storageclasses -o yaml"
  abbr -a -U kgrsy "kubectl get replicasets -o yaml"
  abbr -a -U kgendy "kubectl get endpoints -o yaml"
  abbr -a -U kgqy "kubectl get quotas -o yaml"
  abbr -a -U kglry "kubectl get limitranges -o yaml"
  # k get ... (yaml, fuzzy, neat)
  abbr -a -U kgpof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o yaml | kubectl neat -f -"
  abbr -a -U kgingf "kubectl get ingress | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get ingress {} -o yaml | kubectl neat -f -"
  abbr -a -U kgsvcf "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get service {} -o yaml | kubectl neat -f -"
  abbr -a -U kgcmf "kubectl get configmaps | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get configmap {} -o yaml | kubectl neat -f -"
  abbr -a -U kgsf "kubectl get secrets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get secret {} -o yaml | kubectl neat -f -"
  abbr -a -U kgdsf "kubectl get daemonsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get daemonset {} -o yaml | kubectl neat -f -"
  abbr -a -U kgdf "kubectl get deployments | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get deployment {} -o yaml | kubectl neat -f -"
  abbr -a -U kgpvf "kubectl get persistentvolumes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get persistentvolume {} -o yaml | kubectl neat -f -"
  abbr -a -U kgpvcf "kubectl get persistentvolumeclaims | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get persistentvolumeclaim {} -o yaml | kubectl neat -f -"
  abbr -a -U kgsaf "kubectl get serviceaccounts | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get serviceaccount {} -o yaml | kubectl neat -f -"
  abbr -a -U kgnsf "kubectl get namespaces | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get namespace {} -o yaml | kubectl neat -f -"
  abbr -a -U kgnof "kubectl get nodes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o yaml | kubectl neat -f -"
  abbr -a -U kgcrdf "kubectl get customresourcedefinitions | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get customresourcedefinition {} -o yaml | kubectl neat -f -"
  abbr -a -U kgstsf "kubectl get statefulsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get statefulset {} -o yaml | kubectl neat -f -"
  abbr -a -U kghpaf "kubectl get horizontalpodautoscalers | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get horizontalpodautoscaler {} -o yaml | kubectl neat -f -"
  abbr -a -U kgcjf "kubectl get cronjobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get cronjob {} -o yaml | kubectl neat -f -"
  abbr -a -U kgjf "kubectl get jobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get job {} -o yaml | kubectl neat -f -"
  abbr -a -U kgnetpolf "kubectl get networkpolicies | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get networkpolicy {} -o yaml | kubectl neat -f -"
  abbr -a -U kgrf "kubectl get roles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get role {} -o yaml | kubectl neat -f -"
  abbr -a -U kgrbf "kubectl get rolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get rolebinding {} -o yaml | kubectl neat -f -"
  abbr -a -U kgcrf "kubectl get clusterroles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get clusterrole {} -o yaml  | kubectl neat -f -"
  abbr -a -U kgcrbf "kubectl get clusterrolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get clusterrolebinding {} -o yaml | kubectl neat -f -"
  abbr -a -U kgscf "kubectl get storageclasses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get storageclass {} -o yaml | kubectl neat -f -"
  abbr -a -U kgrsf "kubectl get replicasets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get replicaset {} -o yaml | kubectl neat -f -"
  abbr -a -U kgendf "kubectl get endpoints | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get endpoints {} -o yaml | kubectl neat -f -"
  abbr -a -U kgqf "kubectl get quota | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get quota {} -o yaml | kubectl neat -f -"
  abbr -a -U kglrf "kubectl get limitrange | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get limitrange {} -o yaml | kubectl neat -f -"
  # k describe ... (non-fuzzy)
  abbr -a -U kdpo "kubectl describe pods"
  abbr -a -U kding "kubectl describe ingresses"
  abbr -a -U kdsvc "kubectl describe services"
  abbr -a -U kdcm "kubectl describe configmaps"
  abbr -a -U kds "kubectl describe secrets"
  abbr -a -U kdds "kubectl describe daemonsets"
  abbr -a -U kdd "kubectl describe deployments"
  abbr -a -U kdpv "kubectl describe persistentvolumes"
  abbr -a -U kdpvc "kubectl describe persistentvolumeclaims"
  abbr -a -U kdsa "kubectl describe serviceaccounts"
  abbr -a -U kdns "kubectl describe namespaces"
  abbr -a -U kdno "kubectl describe nodes"
  abbr -a -U kdcrd "kubectl describe customresourcedefinitions"
  abbr -a -U kdsts "kubectl describe statefulsets"
  abbr -a -U kdhpa "kubectl describe horizontalpodautoscalers"
  abbr -a -U kdcj "kubectl describe cronjobs"
  abbr -a -U kdj "kubectl describe jobs"
  abbr -a -U kdnetpol "kubectl describe networkpolicies"
  abbr -a -U kdr "kubectl describe roles"
  abbr -a -U kdrb "kubectl describe rolebindings"
  abbr -a -U kdcr "kubectl describe clusterroles"
  abbr -a -U kdcrb "kubectl describe clusterrolebindings"
  abbr -a -U kdsc "kubectl describe storageclasses"
  abbr -a -U kdrs "kubectl describe replicasets"
  abbr -a -U kdend "kubectl describe endpoints"
  # k describe ... (fuzzy)
  abbr -a -U kdpof "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe pod {}"
  abbr -a -U kdingf "kubectl get ingress | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe ingress {}"
  abbr -a -U kdsvcf "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe service {}"
  abbr -a -U kdcmf "kubectl get configmaps | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe configmap {}"
  abbr -a -U kdsf "kubectl get secrets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe secret {}"
  abbr -a -U kddsf "kubectl get daemonsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe daemonset {}"
  abbr -a -U kddf "kubectl get deployments | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe deployment {}"
  abbr -a -U kdpvf "kubectl get persistentvolumes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe persistentvolume {}"
  abbr -a -U kdpvcf "kubectl get persistentvolumeclaims | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe persistentvolumeclaim {}"
  abbr -a -U kdsaf "kubectl get serviceaccounts | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe serviceaccount {}"
  abbr -a -U kdnsf "kubectl get namespaces | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe namespace {}"
  abbr -a -U kdnof "kubectl get nodes | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe node {}"
  abbr -a -U kdcrdf "kubectl get customresourcedefinitions | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe customresourcedefinition {}"
  abbr -a -U kdstsf "kubectl get statefulsets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe statefulset {}"
  abbr -a -U kdhpaf "kubectl get horizontalpodautoscalers | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe horizontalpodautoscaler {}"
  abbr -a -U kdcjf "kubectl get cronjobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe cronjob {}"
  abbr -a -U kdjf "kubectl get jobs | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe job {}"
  abbr -a -U kdnetpolf "kubectl get networkpolicies | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe networkpolicy {}"
  abbr -a -U kdrf "kubectl get roles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe role {}"
  abbr -a -U kdrbf "kubectl get rolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe rolebinding {}"
  abbr -a -U kdcrf "kubectl get clusterroles | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe clusterrole {}"
  abbr -a -U kdcrbf "kubectl get clusterrolebindings | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe clusterrolebinding {}"
  abbr -a -U kdscf "kubectl get storageclasses | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe storageclass {}"
  abbr -a -U kdrsf "kubectl get replicasets | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe replicaset {}"
  abbr -a -U kdendf "kubectl get endpoints | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe endpoint {}"
  # k delete ... (fuzzy)
  abbr -a -U kdelpof "kubectl get pods | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete pod {} --wait=false --now=true"
  abbr -a -U kdelingf "kubectl get ingress | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete ingress {} --wait=false --now=true"
  abbr -a -U kdelsvcf "kubectl get services | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete service {} --wait=false --now=true"
  abbr -a -U kdelcmf "kubectl get configmaps | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete configmap {} --wait=false --now=true"
  abbr -a -U kdelsf "kubectl get secrets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete secret {} --wait=false --now=true"
  abbr -a -U kdeldsf "kubectl get daemonsets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete daemonset {} --wait=false --now=true"
  abbr -a -U kdeldf "kubectl get deployments | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete deployment {} --wait=false --now=true"
  abbr -a -U kdelpvf "kubectl get persistentvolumes | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete persistentvolume {} --wait=false --now=true"
  abbr -a -U kdelpvcf "kubectl get persistentvolumeclaims | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete persistentvolumeclaim {} --wait=false --now=true"
  abbr -a -U kdelsaf "kubectl get serviceaccounts | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete serviceaccount {} --wait=false --now=true"
  abbr -a -U kdelnsf "kubectl get namespaces | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete namespace {} --wait=false --now=true"
  abbr -a -U kdelnof "kubectl get nodes | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete node {} --wait=false --now=true"
  abbr -a -U kdelcrdf "kubectl get customresourcedefinitions | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete customresourcedefinition {} --wait=false --now=true"
  abbr -a -U kdelstsf "kubectl get statefulsets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete statefulset {} --wait=false --now=true"
  abbr -a -U kdelhpaf "kubectl get horizontalpodautoscalers | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete horizontalpodautoscaler {} --wait=false --now=true"
  abbr -a -U kdelcjf "kubectl get cronjobs | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete cronjob {} --wait=false --now=true"
  abbr -a -U kdeljf "kubectl get jobs | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete job {} --wait=false --now=true"
  abbr -a -U kdelnetpolf "kubectl get networkpolicies | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete networkpolicy {} --wait=false --now=true"
  abbr -a -U kdelrf "kubectl get roles | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete role {} --wait=false --now=true"
  abbr -a -U kdelrbf "kubectl get rolebindings | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete rolebinding {} --wait=false --now=true"
  abbr -a -U kdelrsf "kubectl get replicasets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete replicaset {} --wait=false --now=true"
  abbr -a -U kdelcrf "kubectl get clusterroles | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete clusterrole {} --wait=false --now=true"
  abbr -a -U kdelcrbf "kubectl get clusterrolebindings | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete clusterrolebinding {} --wait=false --now=true"
  abbr -a -U kdelscf "kubectl get storageclasses | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete storageclass {} --wait=false --now=true"
  abbr -a -U kdelendf "kubectl get replicasets | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete replicaset {} --wait=false --now=true"

  # k get event -w  ... (fuzzy)
  abbr -a -U kgpoef "kubectl get pods | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get event -w --field-selector involvedObject.name={}"
  abbr -a -U kgsvcef "kubectl get services | fzf --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get event -w --field-selector involvedObject.name={}"

  # k config ... (fuzzy)
  abbr -a -U kdelctx "kubectl config get-contexts | awk 'NR == 1 || \$1 == \"*\" {\$1=\"\";print;next};1' | column -t | fzf -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl config delete-context {}"
  abbr -a -U kdelclu "kubectl config get-clusters | fzf -m --ansi --header-lines=1 | xargs -I{} -o kubectl config delete-cluster {}"

  # work-only abbreviations
  if tags contains work
    abbr -a -U kdip "kubectl get secrets | awk 'NR==1{print;next};\$2 ~ /kubernetes.io\/dockerconfigjson/ {print}' | fzf --ansi --header-lines=1 -1 | awk '{print \$1}' | xargs -I{} -o kubectl get secret {} -o yaml | yq -r '.data[\".dockerconfigjson\"]' | base64 -D | jq -r '.auths | keys[] as \$key | .[\$key].auth' | base64 -D"
  end
end

# velero abbreviations
if type -q velero
  abbr -a -U v "velero"
  abbr -a -U vbg "velero backup get"
  abbr -a -U vsg "velero schedule get"
  abbr -a -U vbdf "velero backup get | fzf --header-lines=1 | ifne awk '{print \$1}' | xargs -I{} velero backup describe {}"
  abbr -a -U vsdf "velero schedule get | fzf --header-lines=1 | ifne awk '{print \$1}' | xargs -I{} velero schedule describe {}"
  abbr -a -U vblf "velero backup get | fzf --header-lines=1 | ifne awk '{print \$1}' | xargs -I{} velero backup logs {}"
  abbr -a -U vblef "velero backup get | fzf --header-lines=1 | ifne awk '{print \$1}' | xargs -I{} velero backup logs {} | grep -vE 'level=(info|warning)'"
end
