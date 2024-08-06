complete -xc dockr -n __fish_use_subcommand -a context -d "builds and runs a dummy image that lists the context docker gets"
complete -xc dockr -n __fish_use_subcommand -a fexec -d "fuzzy executes a command within a container"
complete -xc dockr -n __fish_use_subcommand -a fsbom -d "fuzzy runs syft to get an image's SBoM"
complete -xc dockr -n __fish_use_subcommand -a fscan -d "fuzzy runs grype to scan images"
complete -xc dockr -n __fish_use_subcommand -a labels -d "list all labels set on an image"
complete -xc dockr -n __fish_use_subcommand -a reclaim -d "shrinks the disk used by the Docker Desktop VM"
complete -xc dockr -n __fish_use_subcommand -a rmc -d "remove containers interactively"
complete -xc dockr -n __fish_use_subcommand -a rmi -d "remove images interactively"
complete -xc dockr -n __fish_use_subcommand -a rmin -d "removes all anonymous images (no repo and no tag/<none>:<none>)"
complete -xc dockr -n __fish_use_subcommand -a rmv -d "remove volumes interactively"
complete -xc dockr -n __fish_use_subcommand -a shell -d "enters the namespace of Docker Desktop (Mac/Win only)"
complete -xc dockr -n __fish_use_subcommand -a tags -d "list all image remote tags"
