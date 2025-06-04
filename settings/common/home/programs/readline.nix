{
  programs.readline = {
    enable = true;
    bindings = {
      # Use the text that has already been typed as the prefix for searching through
      # commands (basically more intelligent Up/Down behavior)
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
      # Use Alt/Meta + Delete to delete the preceding word
      "\\e[3;3~" = "kill-word";
      # macOS Option + Left/Right arrow keys to move the cursor wordwise
      "\\e\\e[C" = "forward-word";
      "\\e\\e[D" = "backward-word";
    };
    variables = {
      bell-style = "visible";
      colored-stats = true;
      completion-ignore-case = true;
      completion-map-case = true;
      completion-prefix-display-length = 3;
      completion-query-items = 200;
      convert-meta = false;
      enable-keypad = true;
      horizontal-scroll-mode = false;
      input-meta = true; # Allow UTF-8 input
      mark-directories = true;
      mark-symlinked-directories = true;
      match-hidden-files = false;
      output-meta = true; # Allow UTF-8 output
      page-completions = false;
      show-all-if-ambiguous = true;
      show-all-if-unmodified = true;
      skip-completed-text = true;
      visible-stats = true;
    };
  };
}
