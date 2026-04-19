{
  inputs,
  ...
}:
{
  flake.homeConfigurations.root'nas = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      (
        { pkgs, ... }:
        {
          home = {
            packages = [
              pkgs.less
              pkgs.nixVersions.latest
            ];
            username = "root";
            homeDirectory = "/root";
            stateVersion = "25.05";
          };
        }
      )
    ];
  };
}
