function pgpz -a cmd -d "gpg for human beings" -w gpg
  switch "$cmd"
    case "export"
      test (count $argv[2..-1]) -lt 1
      and begin
        echo "usage: pgpz export <identity>"
        return 2
      end

      for identity in $argv[2..-1]
        echo "exporting $identity..."
        gpg -o gpg-pubkey-$identity.key.asc --armor --export $identity
        gpg -o gpg-revoke-$identity.crt.asc --armor --gen-revoke $identity
        gpg -o gpg-backup-$identity.pgp.asc --armor --export-secret-keys --export-options export-backup $identity
        gpg -o gpg-privkey-$identity.key.asc --armor --export-secret-keys $identity
      end
    case "" "*"
      gpg $argv
  end
end
