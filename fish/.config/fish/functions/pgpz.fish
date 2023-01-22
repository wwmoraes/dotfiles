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
      # make sure we have executables on path; this is specially needed when
      # calling the function from clean environments such as Hammerspoon
      eval (/usr/libexec/path_helper -c)

      set -l GPG_PRESET_PASSPHRASE (gpgconf --list-dirs libexecdir)/gpg-preset-passphrase

      set -q GPG_OP_ITEM_ID; or begin
        echo "GPG_OP_ITEM_ID not set"
        return 1
      end

      set -l PASSWORD (op item get $GPG_OP_ITEM_ID --fields password | xargs)

      # gpg-connect-agent /bye &> /dev/null
      gpg2 -K --fingerprint --with-colons | sed -nr '/fpr/,+1{s/^grp:+(.*):$/\1/p;}' | while read -l GRIP
        echo "unlocking key grip $GRIP"
        echo $PASSWORD | $GPG_PRESET_PASSPHRASE -c -c $GRIP
      end

      echo "done"
    case "" "*"
      gpg $argv
  end
end
