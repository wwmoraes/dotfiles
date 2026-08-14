{
  flake.modules.darwin.personal = {
    system.defaults.CustomUserPreferences = {
      "com.apple.SafariTechnologyPreview" = {
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback" = false;
        WebKitMediaPlaybackAllowsInline = false;
      };
    };
  };
}
