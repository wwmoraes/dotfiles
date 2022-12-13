complete -ec mb
function mb -a cmd -d "MessageBird toolbox"
  switch "$cmd"
    case gpg-trust
      _mb_gpg-trust
    case gpg-decrypt
      _mb_gpg-decrypt $argv[2..-1]
    case gpg-encrypt
      _mb_gpg-encrypt $argv[2..-1]
    case gcp-config-ssh
      _mb-gcp-config-ssh
    case gcp-ssh
      _mb_gcp-ssh $argv[2..-1]
    case helm
      _mb_helm $argv[2..-1]
    case "" "*"
      echo "Unknown option $cmd"
  end
end

# gpg-trust subcommand
complete -ec _mb_gpg-trust
function _mb_gpg-trust
  echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key $GPG_RECIPIENT trust
  and printf "\n"(set_color -o green)"TL;DR"(set_color normal)" key trusted successfully!"
end
complete -xc mb -n __fish_use_subcommand -a gpg-trust -d "trusts the GPG recipient set on GPG_RECIPIENT"
complete -xc mb -n '__fish_seen_subcommand_from gpg-trust'

# gpg-decrypt subcommand
complete -ec _mb_gpg-decrypt
function _mb_gpg-decrypt
  argparse --name=decrypt 'k/keep' -- $argv
  or return

  test (count $argv) -gt 0; or set argv (fd --hidden -E .git | fzf -m --prompt="select files to decrypt")
  test (count $argv) -gt 0; or return 2

  for filePath in $argv
    printf "%-"(tput cols)"s\r" "[decrypting] "(set_color cyan)$filePath(set_color normal)

    set encryptionID (gpg --pinentry-mode cancel --status-fd 1 -n --list-packets secret-values.yaml.gpg 2> /dev/null | grep ENC_TO | cut -d' ' -f3)
    gpg -K $encryptionID > /dev/null 2>&1
    test $status -eq 0; or begin
      printf "%-"(tput cols)"s\n" "[error] "(set_color cyan)$filePath(set_color normal)" (no key found)"
      continue
    end

    echo "$filePath" | gpg --batch --quiet --yes --decrypt-files
    or printf "%-"(tput cols)"s\n" "[error] "(set_color cyan)$filePath(set_color normal) && continue
    printf "%-"(tput cols)"s\r" "[decrypted] "(set_color cyan)$filePath(set_color normal)

    string length -q -- $_flag_keep; or begin
      printf "%-"(tput cols)"s\r" "[removing] "(set_color cyan)$filePath(set_color normal)
      rm "$filePath"
    end
    printf "%-"(tput cols)"s\n" "[done] "(set_color cyan)$filePath(set_color normal)
  end
end
complete -xc mb -n __fish_use_subcommand -a gpg-decrypt -d "recursively decrypts all gpg files on given (or current) directory"
complete -c mb -n '__fish_seen_subcommand_from gpg-decrypt'

# gpg-encrypt subcommand
complete -ec _mb_gpg-encrypt
function _mb_gpg-encrypt
  argparse --name=encrypt 'k/keep' -- $argv
  or return

  set -q GPG_RECIPIENT; or begin
    echo "Error: set GPG_RECIPIENT environment variable with the GPG recipient to use"
    return 1
  end

  gpg -k $GPG_RECIPIENT > /dev/null 2>&1
  test $status -eq 0; or begin
    echo "Error: no public key found for recipient $GPG_RECIPIENT"
    return 1
  end

  test (count $argv) -gt 0; or set argv (fd --hidden -E .git | fzf -m --prompt="select files to encrypt")
  test (count $argv) -gt 0; or return

  for filePath in $argv
    printf "%-"(tput cols)"s\r" "[checking] "(set_color cyan)$filePath(set_color normal)

    if not test -f $filePath
      printf "%-"(tput cols)"s\n" "[not found] "(set_color cyan)$filePath(set_color normal)
      continue
    end

  printf "%-"(tput cols)"s\r" "[encrypting] "(set_color cyan)$filePath(set_color normal)
  gpg --batch --encrypt-files --yes -r $GPG_RECIPIENT "$filePath"

  string length -q -- $_flag_keep; or begin
    printf "%-"(tput cols)"s\r" "[removing] "(set_color cyan)$filePath(set_color normal)
    rm "$filePath"
  end
  printf "%-"(tput cols)"s\n" "[done] "(set_color cyan)$filePath".gpg"(set_color normal)
  end
end
complete -c mb -n __fish_use_subcommand -a gpg-encrypt -d "encrypts files using the gpg recipient on environment"
complete -c mb -n '__fish_seen_subcommand_from gpg-encrypt'

# gcp-config-ssh subcommand
complete -ec _mb_gcp-config-ssh
function _mb_gcp-config-ssh
  gcloud projects list | \
    grep --line-buffered -vE "^(sys-|mb-t-)" | \
    awk 'NR==1{next};{print $1}' | \
    xargs -I% gcloud compute config-ssh --ssh-config-file=~/.ssh/config.d/profiles/messagebird/% --project=%
end
complete -xc mb -n __fish_use_subcommand -a gcp-config-ssh -d "configures ssh hosts using gcloud tool"

# gcp-ssh subcommand
complete -ec _mb_gcp-ssh
function _mb_gcp-ssh
  set interactive (not contains -- -i $argv; echo $status)

  # non-interactive defaults
  if test $interactive -eq 0
    set project (gcloud config get-value core/project | tail -n 1)
  else
    # remove the interactive flag from argv as it'll be passed forward to gcloud
    if set -l index (contains -i -- -i $argv)
      set -e argv[$index]
    end
  end

  set -q project; or set project (gcloud projects list | \
    grep -vE "^(sys-|mb-t-)" | fzf --header-lines=1 --prompt="GCP Project: " | awk '{print $1}')
  test -z $project; and return 2

  # set -l host (gcloud compute instances list --project=$project | \
  #   fzf --header-lines=1 | \
  #   awk '{print "zones/"$2"/instances/"$1}')
  # test -z $host; and return 2
  # gcloud compute ssh projects/$project/$host

  printf "Project: "(set_color yellow)$project(set_color normal)
  gcloud compute instances list --project=$project | \
    fzf --header-lines=1 --ansi --prompt="Compute instance: " | \
    awk '{print $1,$2}' | read host zone
  test -z $host; and return 2
  test -z $zone; and return 2

  printf "connecting to "(set_color yellow)$project(set_color normal)" => "(set_color yellow)$host(set_color normal)"...\n"
  gcloud compute ssh $argv --project=$project --zone=$zone $host
end
complete -xc mb -n __fish_use_subcommand -a gcp-ssh -d "ssh into gcp hosts"

# helm subcommand
complete -ec _mb_helm
function _mb_helm -w helm
  # get context right away, to prevent changes middle way
  set CONTEXT (kubectl config get-contexts | tail +2 | awk '$1 == "*" {print $0}')
  argparse -i 'o/old' 'n/namespace=' 'v/version=' -- $argv

  # set the helm version or use the default one
  test (string length -- $_flag_version || echo 0) -gt 0
  and set HELM_BIN "helm-$_flag_version"
  or set HELM_BIN helm

  # early check if the helm version exists
  # TODO install missing helm version?
  command -q $HELM_BIN; or begin
    echo "$HELM_BIN not found or is not executable"
    return 1
  end

  # setup helm/tiller variables
  set HELM_TILLER_PORT 44134
  set HELM_TILLER_PROBE_PORT 44135
  set HELM_HOST 127.0.0.1:$HELM_TILLER_PORT
  set HELM_TLS_ENABLE "true"
  set HELM_TLS_VERIFY "true"
  # MB-specific
  set HELM_SECRET_NAME helm-secret
  set TILLER_DEPLOY_NAME tiller-deploy
  set HELM_TILLER_STORAGE secret

  # get namespace from flag or kubectl
  test (string length -- $_flag_namespace || echo 0) -gt 0
  and set NAMESPACE $_flag_namespace
  or set NAMESPACE (echo $CONTEXT | awk '{print $5}')

  test (string length -- $NAMESPACE || echo 0) -gt 0; or begin
    echo "no namespace provided - set one using -n/--namespace or set on kubectl's context"
    return 1
  end

  # check if the namespace exists
  kubectl get namespace $NAMESPACE > /dev/null
  and echo "namespace $NAMESPACE exists"
  or return 1

  # set "old" cluster (messagebird-live) or new cluster tiller namespace
  if test (string length -- $_flag_old || echo 0) -gt 0
    set TILLER_NAMESPACE cluster-tiller
  else
    set TILLER_NAMESPACE $NAMESPACE-helm
  end

  # check if tiller namespace exists
  kubectl get namespace $TILLER_NAMESPACE > /dev/null
  and echo "namespace $TILLER_NAMESPACE exists"
  or return 1

  # check if tiller is deployed
  kubectl -n $TILLER_NAMESPACE get deployment $TILLER_DEPLOY_NAME > /dev/null
  and echo "tiller deployment $TILLER_DEPLOY_NAME exists"
  or return 1

  kubectl -n $TILLER_NAMESPACE get secret $HELM_SECRET_NAME > /dev/null
  and echo "tiller secret $HELM_SECRET_NAME exists"
  or return 1

  # setup home and TLS file paths to cache those
  set HELM_HOME_KEY (echo $CONTEXT | awk '{print $3}')/$TILLER_NAMESPACE
  set -q HELM_HOME; or set HELM_HOME $HOME/.helm/certificates/$HELM_HOME_KEY
  set HELM_TLS_CA_CERT $HELM_HOME/ca.pem
  set HELM_TLS_CERT $HELM_HOME/cert.pem
  set HELM_TLS_KEY $HELM_HOME/key.pem
  set HELM_TILLER_LOGS true
  set HELM_TILLER_LOGS_DIR $HELM_HOME/$argv[1].log

  # fetch certificates if needed
  test -d "$HELM_HOME"; or mkdir -p "$HELM_HOME"
  test -f "$HELM_TLS_CA_CERT"; or begin
    echo "fetching missing CA for $NAMESPACE..."
    kubectl get secret "$HELM_SECRET_NAME" \
      -n "$TILLER_NAMESPACE" \
      -o go-template='{{ index .data "ca.crt" }}' | \
      base64 -D > $HELM_TLS_CA_CERT
  end
  test -f "$HELM_TLS_CERT"; or begin
    echo "fetching missing CA for $NAMESPACE..."
    kubectl get secret "$HELM_SECRET_NAME" \
      -n "$TILLER_NAMESPACE" \
      -o go-template='{{ index .data "helm.crt" }}' | \
      base64 -D > "$HELM_TLS_CERT"
  end
  test -f "$HELM_TLS_KEY"; or begin
    echo "fetching missing CA for $NAMESPACE..."
    kubectl get secret "$HELM_SECRET_NAME" \
      -n "$TILLER_NAMESPACE" \
      -o go-template='{{ index .data "helm.key" }}' | \
      base64 -D > "$HELM_TLS_KEY"
  end

  # run kubectl proxy in the background
  echo "port-forwarding tiller..."
  kubectl port-forward \
    deployment/$TILLER_DEPLOY_NAME \
    -n $TILLER_NAMESPACE \
    $HELM_TILLER_PORT:$HELM_TILLER_PORT \
    $HELM_TILLER_PROBE_PORT:$HELM_TILLER_PROBE_PORT > /dev/null &
  test $status -eq 1; and return 1
  set PROXY_PID (jobs -lp | tail +1)
  disown $PROXY_PID
  # fish's trap cmd EXIT
  function _mb_helm_stop_proxy V PROXY_PID --on-event fish_postexec
    functions -e _mb_helm_stop_proxy_$PROXY_PID
    echo ""
    echo "stopping port-forward..."
    kill $PROXY_PID > /dev/null 2>&1
    echo "done"
  end
  echo ""

  # HELM_TLS_ENABLE and HELM_TLS_VERIFY are not working as expected
  # wait, something helm-related is not working? that's SO unusual! 🙄
  set NON_TLS_COMMANDS version help
  test (contains $argv[1] $NON_TLS_COMMANDS; echo $status) -ne 0
  and $HELM_BIN $argv --tls --tls-verify
  or $HELM_BIN $argv
end
# complete -c mb -n __fish_use_subcommand -a helm -d "easy helm"
# complete -xc mb -n '__fish_seen_subcommand_from helm'
