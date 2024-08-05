function pgpz -a cmd -d "gpg for human beings" -w gpg
  command -q gpg; or echo "gpg is not installed" && return

  switch "$cmd"
    case "export"
      test (count $argv[2..-1]) -lt 1
      and begin
        echo "usage: pgpz export <identity>"
        return 2
      end

      for identity in $argv[2..-1]
        echo "exporting $identity..."
        mkdir "gpg-$identity"
        gpg -o gpg-$identity/public-key.asc --armor --export $identity
        gpg -o gpg-$identity/revoke.asc --armor --gen-revoke $identity
        gpg -o gpg-$identity/backup.asc --armor --export-secret-keys --export-options export-backup $identity
        gpg -o gpg-$identity/secret-key.asc --armor --export-secret-keys $identityf
      end
    case "" "*"
      gpg $argv
  end
end
