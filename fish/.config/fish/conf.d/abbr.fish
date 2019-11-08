# Abbreviations available only in interactive shells
if status --is-interactive
  # git abbreviations
  if test (type -q git)
    abbr -a -g gco git checkout
  end

  # kubectl abbreviations
  if test (type -q kubectl)
    abbr -a -g k kubectl
    abbr -a -g kgp kubectl get pods
  end

  # work abbreviations
  if test (hostname) = "Williams-MacBook-Pro.local"
    abbr -a -g klh kubectl config use-context kubernetes-admin@kind
    abbr -a -g kt1 kubectl config use-context gke_mb-k8s-tst_us-west1_uswe1
    abbr -a -g kt4 kubectl config use-context gke_mb-k8s-tst_europe-west4_euwe4
  end
end
