{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    system = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable system-wide (aka rootful) containerd and its dependencies
        (BuildKit, Stargz Snapshotter) Note that `nerdctl.lima` only works in
        rootless mode; you have to use `lima sudo nerdctl ...` to use rootful
        containerd with nerdctl.
      '';
    };
    user = mkOption {
      type = nullOr bool;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: true (for x86_64 and aarch64)
      '';
      description = ''
        Enable user-scoped (aka rootless) containerd and its dependencies.
      '';
    };
    archives = mkOption {
      type = listOf (submodule ./_arch-locator.nix);
      default = [ ];
      defaultText = lib.literalMD ''
        Lima built-in default: hard-coded URL with hard-coded digest (see the
        output of `limactl info | jq .defaultTemplate.containerd.archives`)
      '';
      description = ''
        Override containerd archive.
      '';
      example = [
        {
          location = "~/Downloads/nerdctl-full-X.Y.Z-linux-amd64.tar.gz";
          arch = "x86_64";
          digest = "sha256:...";
        }
      ];
    };
  };
}
