{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      # used by devShells mostly; for hosts inputs should configure nixpkgs.overlays
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
      };
    };
}
