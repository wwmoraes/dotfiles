{
  flake.modules.darwin.default = {
    # We cannot use a homeManager module to set targets.darwin as home-manager
    # asserts the host platform to be *-darwin when it is set. Makes one
    # wonder what's even the point of such property then...
    home-manager.sharedModules = [
      {
        targets.darwin.defaults = {
          "com.apple.CloudSubscriptionFeatures.optIn" = {
            "412681963" = false; # Disable Apple Intelligence (as tested on Tahoe 26.2)
            "545129924" = false; # Disable Apple Intelligence (per https://macos-defaults.com/misc/apple-intelligence.html)
          };
        };
      }
    ];
  };
}
