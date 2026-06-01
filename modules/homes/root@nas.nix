{
  inputs,
  self,
  ...
}:
{
  flake.homeConfigurations.root'nas = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      self.modules.homeManager.default
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

          services = {
            laminar = {
              enable = true;
              user = "william";
              settings = {
                LAMINAR_BIND_HTTP = "127.0.0.1:8080";
                LAMINAR_HOME = "/volume1/docker/services/laminar";
              };
            };
          };
        }
      )
    ];
  };
}
