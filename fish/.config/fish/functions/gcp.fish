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
    set -l active (gcloud config get-value core/project | tail -n 1)
    set -l selected (gcloud projects list | \
      sed -E "s/(^$active .*)/"(set_color yellow)"\1"(set_color normal)"/" | \
      fzf --ansi --header-lines=1 | \
      awk '{print $1}')
    test -z "$selected"; or gcloud config set project $selected
  case region zone
    set -l selected (gcloud compute zones list | fzf --ansi --header-lines=1)
    test -z "$selected"; and return

    set -l zone (echo $selected | awk '{print $1}')
    set -l region (echo $selected | awk '{print $2}')

    gcloud config set compute/zone $zone
    gcloud config set compute/region $region
  case dashboard
    test (count $argv) -eq 2;
      and set -l project $argv[2];
      or set -l project (gcloud config get-value core/project | tail -n 1)

    ext-open "https://console.cloud.google.com/home/dashboard?project=$project"
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
