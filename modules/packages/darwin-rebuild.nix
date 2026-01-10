{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages = lib.optionalAttrs pkgs.stdenvNoCC.isDarwin {
        darwin-rebuild =
          let
            extraPath = pkgs.lib.makeBinPath (
              with pkgs;
              [
                coreutils
                jq
                git
              ]
            );
            nixPath = pkgs.lib.concatStringsSep ":" [
              "darwin-config=/etc/nix-darwin/configuration.nix"
              "/nix/var/nix/profiles/per-user/root/channels"
            ];
            path = pkgs.lib.concatStringsSep ":" [
              "${extraPath}"
              "$HOME/.nix-profile/bin"
              "/etc/profiles/per-user/$USER/bin"
              "/run/current-system/sw/bin"
              "/nix/var/nix/profiles/default/bin"
              "/usr/local/bin"
              "/usr/bin"
              "/bin"
              "/usr/sbin"
              "/sbin"
            ];
            profile = "/nix/var/nix/profiles/system";
          in
          pkgs.replaceVarsWith rec {
            name = "darwin-rebuild";
            src = ./darwin-rebuild.bash;
            dir = "bin";
            isExecutable = true;
            meta.mainProgram = name;
            replacements = {
              inherit path nixPath profile;
              inherit (pkgs.stdenv) shell;
            };
          };
      };
    };
}
