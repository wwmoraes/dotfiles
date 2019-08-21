# Abbreviations available only in interactive shells
if status --is-interactive
    # git abbreviations
    if test command -qs git
        abbr -a -g gco git checkout
    end

    # kubectl abbreviations
    if test command -qs kubectl
        abbr -a -g k kubectl
        abbr -a -g kgp kubectl get pods
    end

    # work abbreviations
    if test (whoami) = "william.artero"
        abbr -a -g klocal kubectl config use-context kubernetes-admin@kind
        abbr -a -g kqa kubectl config use-context william.artero-qa.k8s.dafiti.local
        abbr -a -g klive kubectl config use-context william.artero-live.k8s.dafiti.local
    end
end