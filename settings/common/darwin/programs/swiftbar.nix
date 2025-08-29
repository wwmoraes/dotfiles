{
  homebrew.casks = [
    "swiftbar"
  ];

  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        targets.darwin.defaults."com.ameba.SwiftBar" =
          let
            rootFolder = builtins.toString (
              /. + config.home.homeDirectory + "/Library/Application Support/SwiftBar"
            );
          in
          {
            DisableBashWrapper = true;
            MakePluginExecutable = false;
            NSNavLastRootDirectory = rootFolder;
            PluginDebugMode = true;
            PluginDeveloperMode = true;
            PluginDirectory = rootFolder + "/plugins";
            StealthMode = true;
            StreamablePluginDebugOutput = false;
          };
      }
    )
  ];
}
