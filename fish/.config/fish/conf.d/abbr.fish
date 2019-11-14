# Abbreviations available only in interactive shells
if status --is-interactive
  # git abbreviations
  if type -q git
    abbr -a -g gco git checkout
  end

  # kubectl abbreviations
  if type -q kubectl
    abbr -a -g k kubectl
    abbr -a -g kgpo kubectl get pods
    abbr -a -g kging kubectl get ingress
    abbr -a -g kgsvc kubectl get services
    abbr -a -g kgcm kubectl get configmaps
    abbr -a -g kgs kubectl get secrets
    abbr -a -g kgds kubectl get daemonsets
    abbr -a -g kgd kubectl get deployments
    abbr -a -g kgpv kubectl get persistentvolumes
    abbr -a -g kgpvc kubectl get persistentvolumeclaims
    abbr -a -g kgsa kubectl get serviceaccounts
    abbr -a -g kgns kubectl get namespaces
    abbr -a -g kgno kubectl get nodes
    abbr -a -g kgcrd kubectl get customresourcedefinitions
    abbr -a -g kgsts kubectl get statefulsets
    abbr -a -g kghpa kubectl get horizontalpodautoscalers
    abbr -a -g kgcj kubectl get cronjobs
    abbr -a -g kgj kubectl get jobs
    abbr -a -g kgnetpol kubectl get networkpolicies
    abbr -a -g kgr kubectl get roles
    abbr -a -g kgrb kubectl get rolebindings
    abbr -a -g kgcr kubectl get clusterroles
    abbr -a -g kgcrb kubectl get clusterrolebindings
    abbr -a -g kgsc kubectl get storageclasses
  end

  # work abbreviations
  if test (hostname) = "Williams-MacBook-Pro.local"
  end
end
