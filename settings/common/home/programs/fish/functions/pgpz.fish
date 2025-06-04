command -q gpg; or echo "gpg is not installed" && return

switch "$cmd"
    case card-enable-ssh
        set -l KEYGRIP (gpg --card-status --with-colons | grep '^grp:' | cut -d: -f4)
        test -n "$KEYGRIP"; or begin
            echo "card has no authentication key set"
            return 1
        end

        echo "configuring authentication key for SSH"
        gpg-connect-agent "KEYATTR $KEYGRIP Use-for-ssh: true" /bye
    case card-setup
        pgpz card-enable-ssh
    case card-switch
        set -l fingerprints (gpg --options /dev/null --card-status | grep -B1 "card-no:" | grep "ssb>" | cut -d"/" -f2 | cut -d" " -f1)
        for fingerprint in $fingerprints
            set -l keygrip (gpg --options /dev/null --list-keys --with-keygrip --with-colons $fingerprint! | grep -A1 $fingerprint | grep '^grp:' | cut -d: -f10)
            rm ~/.gnupg/private-keys-v1.d/$keygrip.key 2>/dev/null || true
        end
    case decrypt
        for SOURCE in $argv[2..-1]
            set -l TARGET (basename -s .asc $SOURCE)
            if test "$TARGET" == "$SOURCE"
                echo "source and target file are the same, skipping"
                continue
            end

            gpg --decrypt --output "$TARGET" "$SOURCE"
        end
    case delete-primary-secret-key
        for NAME in $argv[2..-1]
            ## export extra stuff that only makes sense for a primary/certify key
            set -l FINGERPRINT (gpg \
                --options /dev/null \
                --list-secret-keys \
                --with-colons $NAME \
                | grep -A1 '^sec:' | grep '^fpr:' | cut -d: -f10)
            test -n "$FINGERPRINT"; or begin
                echo "no entry found for $NAME, skipping"
                continue
            end

            gpg --delete-secret-keys $FINGERPRINT\!
        end
    case encrypt-personal
        for FILE in $argv[2..-1]
            gpg --sign --encrypt \
                --recipient 6BDD2952FA19C458B9F76BE4ED705C2C5A7C9AE3! \
                --recipient 40DC89874768BF02C9C84E2CAEA527484E842227! \
                --recipient 2366DB1D4DF17F372F41E7B810928EFC7CEDB3EB! \
                --recipient CCB4C29B8C368E06A2AF7771720E15C22723F9DF! \
                --recipient 4DEEF44279F5F8CD781E0B13811D18E830D695EF! \
                "$FILE"
        end
    case export
        test (count $argv[2..-1]) -lt 1
        and begin
            echo "usage: pgpz export <NAME>"
            return 2
        end

        for NAME in $argv[2..-1]
            ## export extra stuff that only makes sense for a primary/certify key
            set -l FINGERPRINT (gpg \
                --options /dev/null \
                --list-keys \
                --with-colons $NAME \
                | grep -A1 '^pub:' | grep '^fpr:' | cut -d: -f10)
            test -f "gpg-$FINGERPRINT/revoke.asc"; or begin
                mkdir "gpg-$FINGERPRINT"
                echo "[$FINGERPRINT] generating revoke certificate..."
                expect (echo '\
                    spawn gpg --output gpg-'$FINGERPRINT'!/revoke.asc --armor --gen-revoke '$FINGERPRINT'!
                    expect "Create a revocation certificate for this key? (y/N)"
                    send -- "y\r"
                    expect "Your decision?"
                    send -- "0\r"
                    expect ">"
                    send -- "\r"
                    expect "Is this okay? (y/N)"
                    send -- "y\r"
                    expect eof' | psub)
                or return 1
            end

            mkdir "gpg-$NAME"

            echo "[$NAME] exporting public key..."
            printf (string join "\n" y 0 "" y) | gpg \
                --options /dev/null \
                --output gpg-$NAME/public.asc \
                --armor \
                --export-options export-backup \
                --export $NAME
            or return 1

            echo "[$NAME] exporting private key..."
            gpg \
                --options /dev/null \
                --output gpg-$NAME/secret-keys.asc \
                --armor \
                --export-options export-backup \
                --export-secret-keys $NAME
            or return 1

            echo "[$NAME] exporting private subkeys..."
            gpg \
                --options /dev/null \
                --output gpg-$NAME/secret-subkeys.asc \
                --armor \
                --export-options export-backup \
                --export-secret-subkeys $NAME
            or return 1
        end
    case export-dane
        gpg --armor --export-options export-dane --export $argv[2..-1]
    case export-email
        for NAME in $argv[2..-1]
            gpg \
                --options /dev/null \
                --output $NAME.pub.asc \
                --armor \
                --export-filter drop-subkey="usage =~ a || usage =~ c" \
                --export-filter keep-uid="uid =~ <$NAME>" \
                --export-options export-minimal \
                --export $NAME
        end
    case export-ssh-key
        for NAME in $argv[2..-1]
            for FINGERPRINT in (gpg \
                --options /dev/null \
                --list-keys \
                --with-subkey-fingerprint \
                --with-colons \
                --keyid-format long $NAME \
                | grep -A1 '^sub:' | grep -A1 ':a::::::23:$' | grep -v '^sub:\|^--$' | cut -d: -f10)
                test -n "$FINGERPRINT"; or begin
                    echo "$NAME does not have an authentication-only key, skipping"
                    continue
                end

                gpg --options /dev/null --export-ssh-key $FINGERPRINT!
            end
        end
    case export-subkeys
        for NAME in $argv[2..-1]
            for fingerprint in (gpg \
                --options /dev/null \
                --list-keys \
                --with-subkey-fingerprint \
                --with-colons \
                --keyid-format long $NAME \
                | grep '^fpr:')
                pgpz export $fingerprint!
            end
        end
    case list-encryption-fingerprints
        gpg \
            --options /dev/null \
            --list-keys \
            --with-colons $argv[2..1] \
            | grep -A1 '^sub:' | grep -A1 ':e::::::23:$' | grep '^fpr:' | cut -d: -f10
    case list-revoked
        gpg \
            --options /dev/null \
            --list-keys \
            --list-options show-unusable-subkeys \
            --with-colons $argv[2..-1] \
            | grep -A1 '^sub:r:' | grep '^fpr:' | cut -d: -f10
    case "" "*"
        gpg $argv
end
