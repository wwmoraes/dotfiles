{
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      # TODO review IFD and factor it out if possible
      devShells.default = import (self + /shell.nix) {
        inherit pkgs;
        inherit (pkgs.stdenv.hostPlatform) system;
      };
    };
}
