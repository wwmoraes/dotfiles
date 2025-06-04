{
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.kubectl-neat
    (pkgs.kubectx.overrideAttrs (prev: {
      # TODO create wrapper derivations to fully leverage upstream cache
      postInstall =
        (prev.postInstall or "")
        + ''
          mv $out/bin/kubectx $out/bin/kubectl-ctx
          mv $out/bin/kubens $out/bin/kubectl-ns
        '';
    }))
    # pkgs.kubernetes-helmPlugins.helm-diff
    # pkgs.kubernetes-helmPlugins.helm-git
    # pkgs.kubernetes-helmPlugins.helm-s3
    # pkgs.kubernetes-helmPlugins.helm-secrets
  ];

  programs.fish = {
    shellAbbrs = lib.mkMerge [
      {
        k = "kubectl";
        kctx = "kubectl ctx";
        kdcj = "kubectl describe cronjobs";
        kdcm = "kubectl describe configmaps";
        kdcr = "kubectl describe clusterroles";
        kdcrb = "kubectl describe clusterrolebindings";
        kdcrd = "kubectl describe customresourcedefinitions";
        kdd = "kubectl describe deployments";
        kdds = "kubectl describe daemonsets";
        kdend = "kubectl describe endpoints";
        kdhpa = "kubectl describe horizontalpodautoscalers";
        kding = "kubectl describe ingresses";
        kdj = "kubectl describe jobs";
        kdnetpol = "kubectl describe networkpolicies";
        kdno = "kubectl describe nodes";
        kdns = "kubectl describe namespaces";
        kdpo = "kubectl describe pods";
        kdpv = "kubectl describe persistentvolumes";
        kdpvc = "kubectl describe persistentvolumeclaims";
        kdr = "kubectl describe roles";
        kdrb = "kubectl describe rolebindings";
        kdrs = "kubectl describe replicasets";
        kds = "kubectl describe secrets";
        kdsa = "kubectl describe serviceaccounts";
        kdsc = "kubectl describe storageclasses";
        kdsts = "kubectl describe statefulsets";
        kdsvc = "kubectl describe services";
        kecj = "kubectl edit cronjob";
        kecm = "kubectl edit configmap";
        kecr = "kubectl edit clusterrole";
        kecrb = "kubectl edit clusterrolebinding";
        kecrd = "kubectl edit customresourcedefinition";
        ked = "kubectl edit deployment";
        keds = "kubectl edit daemonset";
        kehpa = "kubectl edit horizontalpodautoscaler";
        keing = "kubectl edit ingress";
        kej = "kubectl edit job";
        kenetpol = "kubectl edit networkpolicy";
        keno = "kubectl edit node";
        kens = "kubectl edit namespace";
        kepo = "kubectl edit pod";
        kepv = "kubectl edit persistentvolume";
        kepvc = "kubectl edit persistentvolumeclaim";
        keq = "kubectl edit quota";
        ker = "kubectl edit role";
        kerb = "kubectl edit rolebinding";
        kers = "kubectl edit replicaset";
        kes = "kubectl edit secret";
        kesa = "kubectl edit serviceaccount";
        kesc = "kubectl edit storageclass";
        kests = "kubectl edit statefulset";
        kesvc = "kubectl edit service";
        kg = "kubectl get";
        kga = "kubectl get all";
        kgcj = "kubectl get cronjobs";
        kgcjy = "kubectl get cronjobs -o yaml";
        kgcm = "kubectl get configmaps";
        kgcmy = "kubectl get configmaps -o yaml";
        kgcr = "kubectl get clusterroles";
        kgcrb = "kubectl get clusterrolebindings";
        kgcrby = "kubectl get clusterrolebindings -o yaml";
        kgcrd = "kubectl get customresourcedefinitions";
        kgcrdy = "kubectl get customresourcedefinitions -o yaml";
        kgcry = "kubectl get clusterroles -o yaml";
        kgd = "kubectl get deployments";
        kgds = "kubectl get daemonsets";
        kgdsy = "kubectl get daemonsets -o yaml";
        kgdy = "kubectl get deployments -o yaml";
        kge = "kubectl get events";
        kgend = "kubectl get endpoints";
        kgendy = "kubectl get endpoints -o yaml";
        kghpa = "kubectl get horizontalpodautoscalers";
        kghpay = "kubectl get horizontalpodautoscalers -o yaml";
        kging = "kubectl get ingresses";
        kgingy = "kubectl get ingresses -o yaml";
        kgj = "kubectl get jobs";
        kgjy = "kubectl get jobs -o yaml";
        kglr = "kubectl get limitranges";
        kglry = "kubectl get limitranges -o yaml";
        kgnetpol = "kubectl get networkpolicies";
        kgnetpoly = "kubectl get networkpolicies -o yaml";
        kgno = "kubectl get nodes";
        kgnoy = "kubectl get nodes -o yaml";
        kgns = "kubectl get namespaces";
        kgnsy = "kubectl get namespaces -o yaml";
        kgpo = "kubectl get pods";
        kgpoy = "kubectl get pods -o yaml";
        kgpv = "kubectl get persistentvolumes";
        kgpvc = "kubectl get persistentvolumeclaims";
        kgpvcy = "kubectl get persistentvolumeclaims -o yaml";
        kgpvy = "kubectl get persistentvolumes -o yaml";
        kgqy = "kubectl get quotas -o yaml";
        kgr = "kubectl get roles";
        kgrb = "kubectl get rolebindings";
        kgrby = "kubectl get rolebindings -o yaml";
        kgrs = "kubectl get replicasets";
        kgrsy = "kubectl get replicasets -o yaml";
        kgry = "kubectl get roles -o yaml";
        kgs = "kubectl get secrets";
        kgsa = "kubectl get serviceaccounts";
        kgsay = "kubectl get serviceaccounts -o yaml";
        kgsc = "kubectl get storageclasses";
        kgscy = "kubectl get storageclasses -o yaml";
        kgsts = "kubectl get statefulsets";
        kgstsy = "kubectl get statefulsets -o yaml";
        kgsvc = "kubectl get services";
        kgsvcy = "kubectl get services -o yaml";
        kgsy = "kubectl get secrets -o yaml";
        kl = "kubectl logs";
        kns = "kubectl ns";
        kpf = "kubectl port-forward";
        ksh = " kubectl iexec";
      }
    ];

    shellAliases = lib.mkMerge [
      {
        kdcjf = "kubectl get cronjobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe cronjob {}";
        kdcmf = "kubectl get configmaps | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe configmap {}";
        kdcrbf = "kubectl get clusterrolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe clusterrolebinding {}";
        kdcrdf = "kubectl get customresourcedefinitions | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe customresourcedefinition {}";
        kdcrf = "kubectl get clusterroles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe clusterrole {}";
        kddf = "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe deployment {}";
        kddsf = "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe daemonset {}";
        kdelcjf = "kubectl get cronjobs | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete cronjob {} --wait=false --now=true";
        kdelclu = "kubectl config get-clusters | fzf -0 -m --ansi --header-lines=1 | xargs -I{} -o kubectl config delete-cluster {}";
        kdelcmf = "kubectl get configmaps | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete configmap {} --wait=false --now=true";
        kdelcrbf = "kubectl get clusterrolebindings | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete clusterrolebinding {} --wait=false --now=true";
        kdelcrdf = "kubectl get customresourcedefinitions | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete customresourcedefinition {} --wait=false --now=true";
        kdelcrf = "kubectl get clusterroles | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete clusterrole {} --wait=false --now=true";
        kdelctx = "kubectl config get-contexts | awk 'NR == 1 || \$1 == \"*\" {\$1=\"\";print;next};1' | column -t | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl config delete-context {}";
        kdeldf = "kubectl get deployments | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete deployment {} --wait=false --now=true";
        kdeldsf = "kubectl get daemonsets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete daemonset {} --wait=false --now=true";
        kdelendf = "kubectl get replicasets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete replicaset {} --wait=false --now=true";
        kdelf = ''kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret | awk 'NF > 0 && \$1 != \"NAME\" {print \$1}' | fzf -0 -m --ansi | xargs -I{} -o kubectl delete {} --wait=false --now=true'';
        kdelhpaf = "kubectl get horizontalpodautoscalers | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete horizontalpodautoscaler {} --wait=false --now=true";
        kdelingf = "kubectl get ingress | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete ingress {} --wait=false --now=true";
        kdeljf = "kubectl get jobs | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete job {} --wait=false --now=true";
        kdelnetpolf = "kubectl get networkpolicies | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete networkpolicy {} --wait=false --now=true";
        kdelnof = "kubectl get nodes | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete node {} --wait=false --now=true";
        kdelnsf = "kubectl get namespaces | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete namespace {} --wait=false --now=true";
        kdelpof = "kubectl get pods | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete pod {} --wait=false --now=true";
        kdelpvcf = "kubectl get persistentvolumeclaims | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete persistentvolumeclaim {} --wait=false --now=true";
        kdelpvf = "kubectl get persistentvolumes | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete persistentvolume {} --wait=false --now=true";
        kdelrbf = "kubectl get rolebindings | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete rolebinding {} --wait=false --now=true";
        kdelrf = "kubectl get roles | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete role {} --wait=false --now=true";
        kdelrsf = "kubectl get replicasets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete replicaset {} --wait=false --now=true";
        kdelsaf = "kubectl get serviceaccounts | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete serviceaccount {} --wait=false --now=true";
        kdelscf = "kubectl get storageclasses | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete storageclass {} --wait=false --now=true";
        kdelsf = "kubectl get secrets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete secret {} --wait=false --now=true";
        kdelstsf = "kubectl get statefulsets | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete statefulset {} --wait=false --now=true";
        kdelsvcf = "kubectl get services | fzf -0 -m --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl delete service {} --wait=false --now=true";
        kdendf = "kubectl get endpoints | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe endpoint {}";
        kdhpaf = "kubectl get horizontalpodautoscalers | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe horizontalpodautoscaler {}";
        kdingf = "kubectl get ingress | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe ingress {}";
        kdjf = "kubectl get jobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe job {}";
        kdnetpolf = "kubectl get networkpolicies | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe networkpolicy {}";
        kdnof = "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe node {}";
        kdnsf = "kubectl get namespaces | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe namespace {}";
        kdpof = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe pod {}";
        kdpvcf = "kubectl get persistentvolumeclaims | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe persistentvolumeclaim {}";
        kdpvf = "kubectl get persistentvolumes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe persistentvolume {}";
        kdrbf = "kubectl get rolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe rolebinding {}";
        kdrf = "kubectl get roles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe role {}";
        kdrsf = "kubectl get replicasets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe replicaset {}";
        kdsaf = "kubectl get serviceaccounts | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe serviceaccount {}";
        kdscf = "kubectl get storageclasses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe storageclass {}";
        kdsf = "kubectl get secrets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe secret {}";
        kdstsf = "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe statefulset {}";
        kdsvcf = "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl describe service {}";
        kecjf = "kubectl get cronjobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit cronjob {}";
        kecmf = "kubectl get configmaps | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit configmap {}";
        kecrbf = "kubectl get clusterrolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit clusterrolebinding {}";
        kecrdf = "kubectl get customresourcedefinitions | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit customresourcedefinition {}";
        kecrf = "kubectl get clusterroles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit clusterrole {}";
        kedf = "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit deployment {}";
        kedsf = "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit daemonset {}";
        keendf = "kubectl get endpoints | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit endpoint {}";
        kehpaf = "kubectl get horizontalpodautoscalers | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit horizontalpodautoscaler {}";
        keingf = "kubectl get ingress | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit ingress {}";
        kejf = "kubectl get jobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit job {}";
        kenetpolf = "kubectl get networkpolicies | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit networkpolicy {}";
        kenof = "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit node {}";
        kensf = "kubectl get namespaces | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit namespace {}";
        kepof = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit pod {}";
        kepvcf = "kubectl get persistentvolumeclaims | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit persistentvolumeclaim {}";
        kepvf = "kubectl get persistentvolumes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit persistentvolume {}";
        kerbf = "kubectl get rolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit rolebinding {}";
        kerf = "kubectl get roles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit role {}";
        kersf = "kubectl get replicasets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit replicaset {}";
        kesaf = "kubectl get serviceaccounts | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit serviceaccount {}";
        kescf = "kubectl get storageclasses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit storageclass {}";
        kesf = "kubectl get secrets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit secret {}";
        kestsf = "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit statefulset {}";
        kesvcf = "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl edit service {}";
        # kfxs = "kubectl get fluxconfigs -A -o go-template --template '{{ range \$config := .items }}{{ with \$config }}{{ .metadata.name }}: {{ .status.lastSyncedCommit }}{{ \"\r\n\" }}{{ end }}{{ end }}' | column -t";
        kgaa = "kubectl get cm,ep,pvc,po,svc,sa,ds,deploy,rs,sts,hpa,vpa,cj,jobs,ing,secret";
        kgaextsvc = "kubectl get services -A | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t";
        kgcjf = "kubectl get cronjobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get cronjob {} -o yaml | kubectl neat -f -";
        kgcmf = "kubectl get configmaps | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get configmap {} -o yaml | kubectl neat -f -";
        kgcrbf = "kubectl get clusterrolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get clusterrolebinding {} -o yaml | kubectl neat -f -";
        kgcrdf = "kubectl get customresourcedefinitions | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get customresourcedefinition {} -o yaml | kubectl neat -f -";
        kgcrf = "kubectl get clusterroles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get clusterrole {} -o yaml  | kubectl neat -f -";
        kgdf = "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get deployment {} -o yaml | kubectl neat -f -";
        kgdsf = "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get daemonset {} -o yaml | kubectl neat -f -";
        kgendf = "kubectl get endpoints | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get endpoints {} -o yaml | kubectl neat -f -";
        kgextsvc = "kubectl get services | awk '\$5 !~ /<none>/ {\$7=\"\";print}' | column -t";
        kghpaf = "kubectl get horizontalpodautoscalers | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get horizontalpodautoscaler {} -o yaml | kubectl neat -f -";
        kgingf = "kubectl get ingress | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get ingress {} -o yaml | kubectl neat -f -";
        kgjf = "kubectl get jobs | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get job {} -o yaml | kubectl neat -f -";
        kglrf = "kubectl get limitrange | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get limitrange {} -o yaml | kubectl neat -f -";
        kgnetpolf = "kubectl get networkpolicies | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get networkpolicy {} -o yaml | kubectl neat -f -";
        kgnoa = "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o  go-template='{{range \$name, \$value := .metadata.annotations}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'";
        kgnof = "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o yaml | kubectl neat -f -";
        kgnol = "kubectl get nodes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get node {} -o  go-template='{{range \$name, \$value := .metadata.labels}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'";
        kgnsf = "kubectl get namespaces | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get namespace {} -o yaml | kubectl neat -f -";
        kgpoa = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o  go-template='{{range \$name, \$value := .metadata.annotations}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'";
        kgpoef = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get event -w --field-selector involvedObject.name={}";
        kgpof = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o yaml | kubectl neat -f -";
        kgpol = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get pod {} -o  go-template='{{range \$name, \$value := .metadata.labels}}{{\$name}}: {{\$value}}{{\"\\n\"}}{{end}}'";
        kgpvcf = "kubectl get persistentvolumeclaims | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get persistentvolumeclaim {} -o yaml | kubectl neat -f -";
        kgpvf = "kubectl get persistentvolumes | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get persistentvolume {} -o yaml | kubectl neat -f -";
        kgqf = "kubectl get quota | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get quota {} -o yaml | kubectl neat -f -";
        kgra = "kubectl api-resources --verbs=list --namespaced -o name | grep -v events | xargs -n 1 kubectl get --show-kind --ignore-not-found";
        kgrbf = "kubectl get rolebindings | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get rolebinding {} -o yaml | kubectl neat -f -";
        kgrf = "kubectl get roles | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get role {} -o yaml | kubectl neat -f -";
        kgrsf = "kubectl get replicasets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get replicaset {} -o yaml | kubectl neat -f -";
        kgsaf = "kubectl get serviceaccounts | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get serviceaccount {} -o yaml | kubectl neat -f -";
        kgscf = "kubectl get storageclasses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get storageclass {} -o yaml | kubectl neat -f -";
        kgsf = "kubectl get secrets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get secret {} -o yaml | kubectl neat -f -";
        kgstsf = "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get statefulset {} -o yaml | kubectl neat -f -";
        kgsvcef = "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get event -w --field-selector involvedObject.name={}";
        kgsvcf = "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl get service {} -o yaml | kubectl neat -f -";
        kldf = "kubectl get deployments | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs deployment/{}";
        kldsf = "kubectl get daemonsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs daemonset/{}";
        klpof = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs {}";
        klssf = "kubectl get statefulsets | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl logs statefulset/{}";
        kosvc = "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs kubectl open-svc";
        kpfing = "kubectl get ingresses | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward ingress.extensions/{} 8080:80";
        kpfpo = "kubectl get pods | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward pod/{} 8080:80";
        kpfsvc = "kubectl get services | fzf -0 -1 --ansi --header-lines=1 | awk '{print \$1}' | xargs -I{} -o kubectl port-forward service/{} 8080:80";
        krt = "kubectl run --rm -it --image=wwmoraes/toolbox --restart=Never toolbox";
      }
    ];
  };
}
