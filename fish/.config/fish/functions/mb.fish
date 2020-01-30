function mb -a cmd -d "MessageBird toolbox"
  switch "$cmd"
    case gpg-trust
      _mb_gpg-trust
    case gpg-decrypt
      _mb_gpg-decrypt $argv[2..-1]
    case gpg-encrypt
      _mb_gpg-encrypt $argv[2..-1]
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
    echo "decrypting "(set_color cyan)$filePath(set_color normal)"..."
    echo "$filePath" | gpg --batch --quiet --yes --decrypt-files; or continue
    echo "removing "(set_color cyan)$filePath(set_color normal)"..."
    rm "$filePath"
  end
end
complete -xc mb -n __fish_use_subcommand -a gpg-decrypt -d "recursively decrypts all gpg files on given (or current) directory"
complete -xc mb -n '__fish_seen_subcommand_from gpg-decrypt'

# gpg-encrypt subcommand
function _mb_gpg-encrypt
  set -q GPG_RECIPIENT; or echo "Error: set GPG_RECIPIENT environment variable with the GPG recipient to use" && return 1
  test (count $argv) -gt 0; or echo "Error: please pass at least one file/directory to encrypt" && return 1

  for filePath in $argv
    if not test -f $filePath
      echo "file $filePath does not exist"
      return 1
    end
  end

  echo "encrypting files..."
  echo $argv | gpg --batch --encrypt-files -r $GPG_RECIPIENT; or return 1

  echo "removing originals..."
  rm $argv
end
complete -xc mb -n __fish_use_subcommand -a gpg-encrypt -d "encrypts files using the gpg recipient on environment"
