{
  flake.modules.homeManager.shell = {
    programs.helix.settings.keys = {
      insert = {
        S-tab = "move_parent_node_start";
      };
      normal = {
        ";" = "command_mode";
        "A-," = "goto_previous_buffer";
        "A-." = "goto_next_buffer";
        "A-/" = "repeat_last_motion";
        A-J = [
          "extend_to_line_bounds"
          "yank"
          "paste_after"
        ];
        A-K = [
          "extend_to_line_bounds"
          "yank"
          "paste_before"
        ];
        A-S-down = [
          "extend_to_line_bounds"
          "yank"
          "paste_after"
        ];
        A-S-up = [
          "extend_to_line_bounds"
          "yank"
          "paste_before"
        ];
        A-down = [
          "extend_to_line_bounds"
          "delete_selection"
          "paste_after"
        ];
        A-j = [
          "extend_to_line_bounds"
          "delete_selection"
          "paste_after"
        ];
        A-k = [
          "extend_to_line_bounds"
          "delete_selection"
          "move_line_up"
          "paste_before"
        ];
        A-up = [
          "extend_to_line_bounds"
          "delete_selection"
          "move_line_up"
          "paste_before"
        ];
        A-w = ":buffer-close";
        # P = ":clipboard-paste-before";
        # R = ":clipboard-paste-replace";
        # Y = ":clipboard-yank";
        # d = [":clipboard-yank-join" "delete_selection"];
        # p = ":clipboard-paste-after";
        # y = ":clipboard-yank-join";
        A-q = ":reflow";
        S-tab = "move_parent_node_start";
        X = [
          "extend_line_up"
          "extend_to_line_bounds"
        ];
        a = [
          "append_mode"
          "collapse_selection"
        ];
        i = [
          "insert_mode"
          "collapse_selection"
        ];
        ins = "insert_mode";
        space = {
          F = "file_picker_in_current_buffer_directory";
        };
        tab = "move_parent_node_end";
        "," = {
          "," = "keep_primary_selection";
          c = ":buffer-close";
          q = ":quit";
          r = ":config-reload";
          s = [
            "split_selection_on_newline"
            ":sort"
            "merge_selections"
          ];
        };
        "[" = {
          j = "jump_backward";
        };
        "]" = {
          j = "jump_forward";
        };
      };
      select = {
        # P = ":clipboard-paste-before";
        # R = ":clipboard-paste-replace";
        # Y = ":clipboard-yank";
        # d = [":clipboard-yank-join" "delete_selection"];
        # p = ":clipboard-paste-after";
        # y = ":clipboard-yank-join";
        S-tab = "extend_parent_node_start";
        X = [
          "extend_line_up"
          "extend_to_line_bounds"
        ];
        tab = "extend_parent_node_end";
      };
    };
  };
}
