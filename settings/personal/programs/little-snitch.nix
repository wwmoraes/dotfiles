{
  pkgs,
  ...
}:
{
  ## doesn't work because of spaces, which nix doesn't support
  ## see https://github.com/NixOS/nix/issues/842
  # environment.systemPath = lib.mkMerge [
  #   (lib.mkOrder 1100 [
  #     "/Applications/Little Snitch.app/Contents/Components" ## TODO little snitch
  #   ])
  # ];
  #
  # home-manager.sharedModules = [({ config, ... }: {
  #   home.file.".local/bin/littlesnitch" = {
  #     executable = true;
  #     source = config.lib.file.mkOutOfStoreSymlink "/Applications/${"Little Snitch.app"}/Contents/Components/littlesnitch";
  #   };
  # })];

  homebrew.casks = [
    (pkgs.lib.local.globalCask "little-snitch")
  ];
}
