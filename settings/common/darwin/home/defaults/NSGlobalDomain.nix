{
  targets.darwin.defaults.NSGlobalDomain = {
    ## To find apps with custom hotkeys set:
    ##   defaults find NSUserKeyEquivalents
    ##   defaults read com.apple.universalaccess com.apple.custommenu.apps
    ## Syntax:
    ##   command = @
    ##   control = ^
    ##   option = ~
    ##   shift = $
    NSUserKeyEquivalents = {
      "Enter Full Screen" = "@^f";
      "Return to Previous Size" = "";
      Bottom = "^$↓"; # U+2193
      "Bottom & Quarters" = "";
      "Bottom & Top" = "~^$↓"; # U+2193
      "Left & Quarters" = "";
      "Left & Right" = "~^$←"; # U+2190
      "Right & Left" = "~^$→"; # U+2192
      "Right & Quarters" = "";
      "Top & Bottom" = "~^$↑"; # U+2191
      "Top & Quarters" = "";
      Centre = "^$c";
      Fill = "^$f";
      Left = "^$←"; # U+2190
      Right = "^$→"; # U+2192
      Top = "^$↑"; # U+2191
    };
  };
}
