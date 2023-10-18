# do nothing if Azure CLI isn't installed
command -q az; or exit

function zz -w az -a cmd -d "Azure CLI simplified - now from Z to Z"
  command -q az; or echo "azure CLI is not installed" && return

  switch "$cmd"
    case faccount
      az account list -o table 2>/dev/null | \
      awk 'NR != 2' | \
      fzf --header-lines=1 | \
      awk '{print $(NF-2)}' | \
      ifne xargs -I% az account set --verbose -s "%"
      az account show
    case frg
      az group list --query '[].name' -o tsv | \
      fzf | \
      ifne xargs -I% az configure --defaults group="%"
    case pr
      ### A big thank you MSFT for not allowing using PATs on your own APIs. Why
      ### the fuck have PATs if you can't use it for something as simple as
      ### creating a PR? Sometimes I wonder why I still try to automate around
      ### stupidity 🙄

      # defaults to the optional remote name passed
      set -l remote $argv[2]
      test -z "$remote"; and begin
        # we bail out on multiple remotes. Better than picking one randomly 🤷‍♂️
        set -l remotesCount (git remote | wc -l | xargs)
        test $remotesCount -gt 1; and begin
          echo "multiple remotes found:"
          git remote
          echo "usage: zz pr [remote-name]"
          return 2
        end
        set -l remote (git remote)
      end
      set -l upstreamURL (git remote get-url $remote)
      set -l baseURL (string replace -r "(.*?://)(?:[^@]*@)?(.*)" "\$1\$2" $upstreamURL)
      set -l sourceRef (git branch --show-current)
      set -l targetRef (git ls-remote --symref $upstreamURL HEAD | sed -nE 's|^ref: refs/heads/([^[:space:]]+)[[:space:]]+HEAD|\1|p')

      echo "creating $sourceRef -> $targetRef PR..."
      echo "$baseURL/pullrequestcreate?sourceRef=$sourceRef&targetRef=$targetRef" | tee /dev/tty | xargs open
    case browse
      set -l repository (basename (git remote get-url origin))
      az repos show -r $repository --query webUrl -o tsv | xargs open
    case "*"
      az $argv
  end
end

complete -xc zz -n __fish_use_subcommand -a faccount -d "fuzzy account switcher"
complete -xc zz -n __fish_use_subcommand -a frg -d "fuzzy default group switcher"
