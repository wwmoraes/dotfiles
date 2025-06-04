{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;
  text = import (/. + modulesPath + /lib/write-text.nix) {
    inherit lib;
    mkTextDerivation =
      name: text:
      pkgs.writeTextFile {
        inherit text;
        name = "sudoers.d-${name}";
        checkPhase = ''
          printf ${lib.escapeShellArg text} | ${lib.getExe' pkgs.nur.repos.wwmoraes.visudo "visudo"} --quiet --check --file -
        '';
        derivationArgs = {
          doCheck = true;
        };
      };
  };
  cfg = config.security.sudo;
in
{
  options = {
    security.sudo = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable the {command}`sudo` command, which
          allows non-root users to execute commands as root.
        '';
      };
      extraConfigFiles = mkOption {
        type = with types; attrsOf (submodule text);
        default = { };
        description = "Contains rules created on separate files under /etc/sudoers.d.";
      };
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts = {
      etc.text = lib.mkAfter config.system.activationScripts.sudoers.text;
      # TODO use /etc/static + cleanup removed entries
      sudoers.text = ''
        echo >&2 "installing /etc/sudoers.d files..."
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: value:
            "install --owner root --group wheel --mode 0644 ${value.source} /etc/sudoers.d/${value.target}"
          ) cfg.extraConfigFiles
        )}
      '';
    };
  };
}
