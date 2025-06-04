{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    types
    mkIf
    mkOption
    ;

  cfg = config.programs.git-ps;
  format = pkgs.formats.toml { };
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
    programs.git-ps = {
      enable = mkEnableOption "Tool for working with a stack of patches";

      # extraPackages = mkOption {
      #   default = [];
      #   type = with types; listOf package;
      # };

      hooks = {
        integrate_post_push = mkOption {
          default = null;
          type = with types; nullOr (either path lines);
        };
        integrate_verify = mkOption {
          default = null;
          type = with types; nullOr (either path lines);
        };
        isolate_post_checkout = mkOption {
          default = null;
          type = with types; nullOr (either path lines);
        };
        isolate_post_cleanup = mkOption {
          default = null;
          type = with types; nullOr (either path lines);
        };
        list_additional_information = mkOption {
          default = null;
          type = with types; nullOr (either path lines);
        };
        request_review_post_sync = mkOption {
          default = null;
          type = with types; nullOr (either path lines);
        };
      };

      package = mkPackageOption pkgs "git-ps" {
        default = [ "git-ps-rs" ];
      };

      settings = mkOption {
        inherit (format) type;
        default = { };
        description = ''
          Git Patch Stack supports various settings via three layers of configuration files.
        '';
        example = lib.literalExpression ''
          {
            branch = {
              push_to_remote = true;
              verify_isolation = true;
            };
            fetch.show_upstream_patches_after_fetch = true;
            integrate = {
              prompt_for_reassurance = false;
              pull_after_integrate = true;
              verify_isolation = true;
            };
            list = {
              add_extra_patch_info = true;
              extra_patch_info_length = 10;
              reverse_order = false;
              alternate_patch_series_colors = true;
            };
            pull.show_list_post_pull = true;
            request_review.verify_isolation = true;
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkIf (cfg.package != null) [
      cfg.package
    ];

    xdg.configFile =
      {
        "git-ps/config.toml" = mkIf (cfg.settings != { }) {
          source = format.generate "git-ps-config.toml" cfg.settings;
        };
      }
      // (lib.concatMapAttrs (name: value: {
        "git-ps/hooks/${name}" = mkIf (value != null) {
          executable = true;
          source = mkIf (builtins.isPath value) value;
          text = mkIf (!builtins.isPath value) value;
        };
      }) cfg.hooks);
  };
}
