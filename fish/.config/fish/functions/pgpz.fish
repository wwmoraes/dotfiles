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
    case "unlock"
      set -l GPG_PRESET_PASSPHRASE (realpath (dirname (which gpg2))/../libexec/gpg-preset-passphrase)

      string length -q $GPG_PRESET_PASSPHRASE; or begin
        echo "gpg-preset-passphrase not found"
        return 1
      end

      set -q GPG_OP_ITEM_ID; or begin
        echo "GPG_OP_ITEM_ID not set"
        return 1
      end

      set -q GPG_KEYGRIP; or begin
        echo "GPG_KEYGRIP not set"
        return 1
      end

      gpg-connect-agent /bye &> /dev/null
      op item get $GPG_OP_ITEM_ID --fields password | $GPG_PRESET_PASSPHRASE --preset $GPG_KEYGRIP
    case "" "*"
      gpg $argv
  end
end
