command -q kustomize; or exit

complete -ec kustomize

complete -xc kustomize -s h -l help -d "help for kustomize"
complete -xc kustomize -l kubeconfig -a "(__fish_complete_path ~/.kube/config Kubeconfig)" -d "Paths to a kubeconfig. Only required if out-of-cluster."

complete -xc kustomize -n '__fish_use_subcommand || __fish_seen_subcommand_from help' -a build -d "Print configuration per contents of kustomization.yaml"
complete -xc kustomize -n '__fish_seen_subcommand_from build' -a "(__fish_complete_directories)"

complete -xc kustomize -n '__fish_use_subcommand || __fish_seen_subcommand_from help' -a create -d "Create a new kustomization in the current directory"
complete -xc kustomize -n '__fish_use_subcommand || __fish_seen_subcommand_from help' -a edit -d "Edits a kustomization file"
complete -xc kustomize -n '__fish_use_subcommand || __fish_seen_subcommand_from help' -a version -d "Prints the kustomize version"
complete -xc kustomize -n '__fish_use_subcommand || __fish_seen_subcommand_from help' -a install-completion -d "Just... don't do it."
complete -xc kustomize -n '__fish_use_subcommand' -a help -d "Help about any command"
