function gcp -a cmd -d "gloud CLI wrapper with extra commands"
  type -q gcloud; or echo "gcloud is not installed" && return
  type -q awk; or echo "awk is not installed" && return
  type -q sed; or echo "sed is not installed" && return
  type -q tail; or echo "tail is not installed" && return
  type -q fzf; or echo "fzf is not installed" && return
  type -q xargs; or echo "xargs is not installed" && return

  switch "$cmd"
  case reauth
    echo "authenticating user..."
    gcloud -q --no-user-output-enabled auth login --brief
    echo "authenticating application-default..."
    gcloud -q --no-user-output-enabled auth application-default login 2> /dev/null
  case setup
    echo "configuring docker..."
    gcloud -q --no-user-output-enabled auth configure-docker 2> /dev/null
    echo "setting up config-helper..."
    gcloud -q --no-user-output-enabled config config-helper 2> /dev/null
  case project
    set active (gcloud config get-value core/project | tail -n 1)
    set selected (gcloud projects list | \
      sed -E "s/(^$active .*)/"(set_color yellow)"\1"(set_color normal)"/" | \
      fzf --ansi --header-lines=1 | \
      awk '{print $1}')
    test -z "$selected"; or gcloud config set project $selected
  case region zone
    set selected (gcloud compute zones list | fzf --ansi --header-lines=1)
    test -z "$selected"; and return

    set zone (echo $selected | awk '{print $1}')
    set region (echo $selected | awk '{print $2}')

    gcloud config set compute/zone $zone
    gcloud config set compute/region $region
  case dashboard
    test (count $argv) -eq 2;
      and set project $argv[2];
      or set project (gcloud config get-value core/project | tail -n 1)

    ext-open "https://console.cloud.google.com/home/dashboard?project=$project"
  case logs
    set interactive (not contains -- -i $argv; echo $status)

    set project (gcloud config get-value core/project | tail -n 1)
    # set defaults for non-interactive usage
    if test $interactive -eq 0
      test (string length $project || echo 0) -eq 0; and return 2

      kubectl config get-contexts | awk '$1 == "*"' | awk '{print $2,$3,$5}' | read contextName contextCluster k8sNamespace
      test (string length $contextName || echo 0) -eq 0; and return 2
      test (string length $contextCluster || echo 0) -eq 0; and return 2
      test (string length $k8sNamespace || echo 0) -eq 0; and return 2

      echo $contextCluster | sed -E 's/gke_'$project'_([^_]+)_([^_]+)/\2 \1/' | read cluster location
      test (string length $cluster || echo 0) -eq 0; and return 2
      test (string length $location || echo 0) -eq 0; and return 2
    else
      set project (gcloud projects list | \
        sed -E "s/(^$project .*)/"(set_color yellow)"\1"(set_color normal)"/" | \
        fzf --ansi --header-lines=1 --prompt="GCP Project > " | \
        awk '{print $1}')
      test (string length $project || echo 0) -eq 0; and return 2

      gcloud --project=$project container clusters list 2> /dev/null | fzf -1 --header-lines=1 --prompt="k8s cluster > " | awk '{print $1,$2}' | read cluster location
      test (string length $cluster || echo 0) -eq 0; and return 2
      test (string length $location || echo 0) -eq 0; and return 2

      set contextName (kubectl config get-contexts | awk '$1 == "*" || NR == 1 {print $2,$3;next};{print $1,$2}' | column -t | grep -e "NAME.*CLUSTER" -e "gke_"$project"_"$location"_"$cluster | fzf -1 --header-lines=1 --prompt="k8s context > " | awk '{print $1}')
      test (string length $contextName || echo 0) -eq 0; and return 2

      set k8sNamespace (kubectl --context=$contextName get namespaces | grep -v -helm | fzf --header-lines=1 --prompt="k8s namespace > " | awk '{print $1}')
      test (string length $k8sNamespace || echo 0) -eq 0; and return 2
    end

    set prompt "Listing pods at GCP project "(set_color yellow)$project(set_color normal)" -> k8s cluster "(set_color yellow)$cluster(set_color normal)" -> namespace "(set_color yellow)$k8sNamespace(set_color normal)
    printf $prompt
    set k8sPodName (kubectl --context=$contextName get pods -n $k8sNamespace | fzf --header-lines=1 --prompt="k8s pod > " | awk '{print $1}')
    test (string length $k8sPodName || echo 0) -eq 0; and return 2

    ext-open "https://console.cloud.google.com/logs/viewer?interval=P7D&project=$project&minLogLevel=0&expandAll=false&customFacets=&limitCustomFacetWidth=true&advancedFilter=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22$project%22%0Aresource.labels.location%3D%22$location%22%0Aresource.labels.cluster_name%3D%22$cluster%22%0Aresource.labels.namespace_name%3D%22$k8sNamespace%22%0Aresource.labels.pod_name%3D%22$k8sPodName%22"
  case "*"
    gcloud $argv
  end
end

complete -ec gcp
complete -c gcp -w gcloud
complete -xc gcp -n __fish_use_subcommand -a reauth -d "reauthenticate everything"
complete -xc gcp -n __fish_use_subcommand -a setup -d "setup docker auth and the config-helper agent"
complete -xc gcp -n __fish_use_subcommand -a project -d "fuzzy set project"
complete -xc gcp -n __fish_use_subcommand -a "region zone" -d "fuzzy set region and zone"
complete -xc gcp -n __fish_use_subcommand -a dashboard -d "open the current/passed project dashboard"
complete -xc gcp -n __fish_use_subcommand -a logs -d "open the stackdriver logs viewer for the chosen pod"
