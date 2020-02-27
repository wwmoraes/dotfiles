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
    case "" "*"
      echo "Unknown option $cmd"
  end
end
complete -ec mb

# gpg-trust subcommand
function _mb_gpg-trust
  echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key $GPG_RECIPIENT trust
  and printf "\n"(set_color -o green)"TL;DR"(set_color normal)" key trusted successfully!"
end
complete -xc mb -n __fish_use_subcommand -a gpg-trust -d "trusts the GPG recipient set on GPG_RECIPIENT"
complete -xc mb -n '__fish_seen_subcommand_from gpg-trust'

# gpg-decrypt subcommand
function _mb_gpg-decrypt
  # use the current directory per default
  test (count $argv) = 0; and set -l argv (pwd)

  echo "searching and decrypting files..."
  find . -type f -name '*.gpg' | while read -l filePath
    printf "%-"(tput cols)"s\r" "[decrypting] "(set_color cyan)$filePath(set_color normal)
    echo "$filePath" | gpg --batch --quiet --yes --decrypt-files
    or printf "%-"(tput cols)"s\n" "[error] "(set_color cyan)$filePath(set_color normal) && continue
    printf "%-"(tput cols)"s\n" "[decrypted] "(set_color cyan)$filePath(set_color normal)

    printf "%-"(tput cols)"s\r" "[removing] "(set_color cyan)$filePath(set_color normal)
    rm "$filePath"
    printf "%-"(tput cols)"s\n" "[removed] "(set_color cyan)$filePath(set_color normal)
  end
end
complete -xc mb -n __fish_use_subcommand -a gpg-decrypt -d "recursively decrypts all gpg files on given (or current) directory"
complete -xc mb -n '__fish_seen_subcommand_from gpg-decrypt'

# gpg-encrypt subcommand
function _mb_gpg-encrypt
  set -q GPG_RECIPIENT; or echo "Error: set GPG_RECIPIENT environment variable with the GPG recipient to use" && return 1
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

  printf "%-"(tput cols)"s\r" "[removing] "(set_color cyan)$filePath(set_color normal)
  rm $filePath
  printf "%-"(tput cols)"s\n" "[done] "(set_color cyan)$filePath".gpg"(set_color normal)
  end
end
complete -xc mb -n __fish_use_subcommand -a gpg-encrypt -d "encrypts files using the gpg recipient on environment"

# gcp-config-ssh subcommand
function _mb_gcp-config-ssh
  gcloud projects list | \
    grep --line-buffered -vE "^(sys-|mb-t-)" | \
    awk 'NR==1{next};{print $1}' | \
    xargs -I% gcloud compute config-ssh --ssh-config-file=~/.ssh/config.d/profiles/messagebird/% --project=%
end
complete -xc mb -n __fish_use_subcommand -a gcp-config-ssh -d "configures ssh hosts using gcloud tool"

# gcp-ssh subcommand
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
