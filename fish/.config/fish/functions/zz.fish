function zz -a cmd -d "Azure CLI simplified - now from Z to Z"
  type -q az; or echo "azure CLI is not installed" && return

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
    case "*"
      az $argv
  end
end
complete -ec zz
complete -c zz -w az

complete -xc zz -n __fish_use_subcommand -a faccount -d "fuzzy account switcher"
complete -xc zz -n __fish_use_subcommand -a frg -d "fuzzy default group switcher"