function work -d "Setup work abbreviations"
  abbr -a -g k kubectl
  abbr -a -g kgp kubectl get pods
  abbr -a -g klocal kubectl config use-context kubernetes-admin@kind
  abbr -a -g kqa kubectl config use-context william.artero-qa.k8s.dafiti.local
  abbr -a -g klive kubectl config use-context william.artero-live.k8s.dafiti.local
  abbr --show
end