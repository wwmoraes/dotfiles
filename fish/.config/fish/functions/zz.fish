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
    case pr
      set -l args $argv[2..-1] --auto-complete --delete-source-branch
      set -l workItem (tmux display-message -p '#S' | string match -r "^[0-9]+\$")

      test (string length -- "$workItem") -gt 0
      and set -a args --work-items $workItem

      echo "creating PR..."
      az repos pr create $args | jq -r '"\(.repository.webUrl)/pullrequest/\(.pullRequestId)"' | xargs open
    case ado
      _zz_ado $argv[2..-1]
    case browse
      set -l repository (basename (git remote get-url origin))
      az repos show -r $repository --query webUrl -o tsv | xargs open
    case dbranch
      set -l branch (git branch --show-current)
      git push --delete origin $branch || true
      git checkout master
      git branch -D $branch || true
    case "*"
      az $argv
  end
end
complete -ec zz
complete -c zz -w az

complete -xc zz -n __fish_use_subcommand -a faccount -d "fuzzy account switcher"
complete -xc zz -n __fish_use_subcommand -a frg -d "fuzzy default group switcher"

function _zz_ado -a cmd
  set method ""
  set endpoint ""
  set responseQuery "."
  set extraArgs
  set queryParams

  argparse 'i/id=' 'd/display-name=' 's/scope=' -- $argv[2..-1]
  test -n "$_flag_display_name"; or set -l _flag_display_name "zz"
  test -n "$_flag_scope"; or set -l _flag_scope "vso.code_manage vso.packaging_manage"

  # hardcoded as per AAB policy
  set -l validTo (date -u -v+15d +"%Y-%m-%dT%H:%M:%S.000Z")
  set -l allOrgs false

  switch "$cmd"
    case h help
      echo "usage: zz ado list"
      echo 'usage: zz ado new [-d|--display-name pat-display-name] [-s|--scope "ado-scope1 ado-scopeN"]'
      echo 'usage: zz ado renew [-i|--id pat-id] [-d|--display-name pat-display-name] [-s|--scope "ado-scope1 ado-scopeN"]'
      return
    case list
      set method "GET"
      set endpoint "/_apis/Tokens/Pats"
      set responseQuery "."
    case renew
      test -n "$_flag_id"; or begin
        echo "please set the PAT ID using -i/--id"
        return 2
      end

      set method "PUT"
      set endpoint "/_apis/Tokens/Pats"
      set responseQuery '.patToken'

      set -l data (jq -n \
        --arg authorizationId "$_flag_id" \
        --arg displayName "$_flag_display_name" \
        --arg scope "$_flag_scope" \
        --arg validTo $validTo \
        --argjson allOrgs $allOrgs \
        '{"authorizationId":$authorizationId,"displayName":$displayName,"scope":$scope,"validTo":$validTo,"allOrgs":$allOrgs}')
      set -a extraArgs --data "$data"
    case new
      set method "POST"
      set endpoint "/_apis/Tokens/Pats"
      set responseQuery '.patToken'

      set -l data (jq -n \
        --arg displayName "$_flag_display_name" \
        --arg scope "$_flag_scope" \
        --arg validTo $validTo \
        --argjson allOrgs $allOrgs \
        '{"displayName": $displayName,"scope": $scope,"validTo": $validTo,"allOrgs": $allOrgs}')
      set -a extraArgs --data "$data"
    case "*"
      az devops $argv
      return
  end

  test (string length -- $method || echo 0) -gt 0; or begin
    echo "no method set"
    return 1
  end
  test (string length -- $endpoint || echo 0) -gt 0; or begin
    echo "no endpoint set"
    return 1
  end

  echo "retrieving Azure access token..."
  set -l accessToken (az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 | jq -r '.accessToken')

  set -l organization (cat ~/.azure/azuredevops/config | grep -E "^organization\s*=" | cut -d'=' -f2 | xargs)
  set -l organizationName (basename $organization)
  set -l apiVersion "7.1-preview.1"
  test (count $queryParams) -gt 0; and begin
    set queryParams '&'(string join "&" $queryParams)
  end

  set url 'https://vssps.dev.azure.com/'$organizationName$endpoint'?api-version='$apiVersion

  curl -fsSL \
    -X $method \
    -H "Authorization: Bearer $accessToken" \
    -H "X-VSS-ForceMsaPassThrough: true" \
    -H "Content-Type: application/json" \
    --url $url \
    $extraArgs | jq $responseQuery
end
