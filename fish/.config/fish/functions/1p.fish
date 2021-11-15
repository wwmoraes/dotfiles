complete -ec 1p -w op -d "1password CLI for human beings"
function 1p -a cmd -d "easy 1Password CLI management" -w op
  switch "$cmd"
    case "login"
      _1p_login $argv[2..-1]
    case "renew"
      _1p_renew $argv[2..-1]
    case "vaults"
      op list vaults $argv | jq -r '.[].name'
    case "*"
      op $argv
  end
end

function _1p_login
  for account in (string split ',' $OP_SESSIONS)
    set -l OP_ADDRESS OP_ADDRESS_$account
    set -q $OP_ADDRESS; or begin
      echo "$OP_ADDRESS not set, skipping account '$account'"
      continue
    end

    set -l OP_EMAIL OP_EMAIL_$account
    set -q $OP_EMAIL; or begin
      echo "$OP_EMAIL not set, skipping account '$account'"
      continue
    end

    set -Ux OP_SESSION_$account (op signin --raw $$OP_ADDRESS $$OP_EMAIL)
  end
end
complete -fc 1p -n __fish_use_subcommand -a login -d "1p: logs into all accounts"

function _1p_renew
  for account in (string split ',' $OP_SESSIONS)
    set -l OP_SESSION OP_SESSION_$account
    set -q $OP_SESSION; or begin
      echo "$OP_SESSION not set, please log in to account '$account'"
      continue
    end

    echo "renewing session token for $account"
    set -Ux $OP_SESSION (op --account $account signin --raw)
  end
end
complete -fc 1p -n __fish_use_subcommand -a renew -d "1p: renew session tokens for all accounts"

complete -fc 1p -n __fish_use_subcommand -a vaults -d "1p: list vaults for humans"
