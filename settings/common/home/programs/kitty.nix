{
  config,
  lib,
  ...
}:
{
  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    keybindings = {
      "cmd+h" = "hide_macos_app";
      "cmd+n" = "new_os_window";
      "cmd+q" = "quit";
      "cmd+m" = "minimize_macos_window";
      "cmd+v" = "paste_from_clipboard";
      "cmd+w" = "close_os_window";
      "ctrl+c" = "send_key ctrl+c";
      "ctrl+cmd+," = "load_config_file";
      "ctrl+cmd+f" = "toggle_fullscreen";
      "ctrl+cmd+space" = "kitten unicode_input";
      "ctrl+shift+f11" = "toggle_fullscreen";
      "ctrl+shift+f5" = "load_config_file";
      "ctrl+shift+u" = "kitten unicode_input";
      "opt+cmd+h" = "hide_macos_other_apps";
      "opt+cmd+s" = "toggle_macos_secure_keyboard_entry";
    };
    settings = {
      clear_all_shortcuts = true;
      disable_ligatures = "cursor";
      mouse_hide_wait = -1.0;
      focus_follows_mouse = false;
      sync_to_monitor = true;
      enable_audio_bell = false;
      visual_bell_duration = 0.3;
      bell_on_tab = "🔔 ";
      confirm_os_window_close = 0;
      tab_bar_style = "hidden";
      shell = "${lib.getExe config.programs.fish.package} --login";
      editor = ".";
      close_on_child_death = true;
      clipboard_control = "write-clipboard write-primary read-clipboard-ask read-primary-ask no-append";
      shell_integration = "enabled";
      term = "xterm-256color";
      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = true;
      macos_thicken_font = 0.5;
      macos_show_window_title_in = "window";
      macos_colorspace = "default";
      kitty_mod = "ctrl+shift";
      # symbol_map = "U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d7,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+ed00-U+efc1,U+f000-U+f2ff,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f533,U+f0001-U+f1af0 Symbols Nerd Font Mono";
    };
    shellIntegration.enableFishIntegration = false;
    extraConfig = ''
      font_features FiraCode-Bold +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCode-Light +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCode-Light +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCode-Medium +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCode-Regular +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCode-Retina +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCode-SemiBold +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeRoman-Bold +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeRoman-Medium +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeRoman-Regular +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeRoman-SemiBold +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNF-Bold +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNF-Light +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNF-Med +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNF-Reg +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNF-Ret +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNF-SemBd +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFM-Bold +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFM-Light +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFM-Med +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFM-Reg +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFM-Ret +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFM-SemBd +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFP-Bold +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFP-Light +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFP-Med +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFP-Reg +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFP-Ret +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
      font_features FiraCodeNFP-SemBd +ss01 +ss03 +ss05 +ss07 +ss09 +cv12 +cv21 +cv25 +cv26 +cv28 +cv29 +cv30
    '';
  };

  xdg.configFile."kitty/unicode-input-favorites.conf".text = ''
    # Favorite characters for unicode input
    # Enter the hex code for each favorite character on a new line. Blank lines are
    # ignored and anything after a # is considered a comment.

    1f5a4 # 🖤 black heart
    1f680 # 🚀 rocket
    1f937 # 🤷 shrug
    1f980 # 🦀 crab
    2013 # – en dash
    2014 # — em dash
    2122 # ™ trade mark sign
    a9 # © copyright sign
    ae # ® registered sign
  '';

  ## TODO remove injected snippet from interactive shell init from hm module
  xdg.configFile."fish/conf.d/kitty.fish".text = ''
    set --query KITTY_INSTALLATION_DIR; or exit

    set --global KITTY_SHELL_INTEGRATION "${config.programs.kitty.shellIntegration.mode}"
    source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
    set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
  '';
}
