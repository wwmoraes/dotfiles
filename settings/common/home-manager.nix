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

              ${gpgconfBin} --kill gpg-agent || true
              ${gpgBin} --card-status > /dev/null || true
            ''
          );
        }
      )
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
