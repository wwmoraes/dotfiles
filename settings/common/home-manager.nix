{
  home-manager = {
    backupFileExtension = "bkp";
    sharedModules = [
      {
        home.enableNixpkgsReleaseCheck = true;
        home.stateVersion = "25.05";
      }
      (
        { config, lib, ... }:
        {
          home.activation.gpgCardSwitch = lib.hm.dag.entryAfter [ "importGpgKeys" "createGpgHomedir" ] (
            let
              gpgBin = lib.getExe config.programs.gpg.package;
              gpgconfBin = lib.getExe' config.programs.gpg.package "gpgconf";
            in
            ''
              export GNUPGHOME=${lib.escapeShellArg config.programs.gpg.homedir}

              for fingerprint in $(${gpgBin} --options /dev/null --card-status 2> /dev/null | grep -B1 "card-no:" | grep "ssb>" | cut -d"/" -f2 | cut -d" " -f1); do
                KEYGRIP=$(${gpgBin} --list-keys --with-keygrip --with-colons $fingerprint! | grep -A1 $fingerprint | grep '^grp:' | cut -d: -f10)
                rm "$GNUPGHOME/private-keys-v1.d/$KEYGRIP.key" 2>/dev/null || true
              done

              ${gpgconfBin} --kill gpg-agent
              ${gpgBin} --card-status > /dev/null
            ''
          );
          home.activation.developerGroupMembership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _developer > /dev/null); then
              echo >&2 "adding user ${config.home.username} to group _developer"
              sudo dscl . append /Groups/_developer GroupMembership "${config.home.username}"
            fi
          '';
          home.activation.webdeveloperGroupMembership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _webdeveloper > /dev/null); then
              echo >&2 "adding user ${config.home.username} to group _webdeveloper"
              sudo dscl . append /Groups/_webdeveloper GroupMembership "${config.home.username}"
            fi
          '';
          ## skipping this for now as the write replaces the group in the policy instead of adding
          # echo "allowing _developer members to change system preferences"
          # # shellcheck disable=SC2024
          # sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
          # sudo defaults write /tmp/system.preferences.plist group _developer
          # # shellcheck disable=SC2024
          # sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
        }
      )
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
