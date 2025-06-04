{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    auto-pairs = mkOption {
      type = nullOr (attrsOf str);
      default = null;
    };
    auto-format = mkOption {
      type = nullOr bool;
      default = null;
    };
    debugger = mkOption {
      type = nullOr (attrsOf anything);
      default = null;
    };
    formatter = mkOption {
      description = ''The formatter for the language, it will take precedence over the lsp when defined. The formatter must be able to take the original file as input from stdin and write the formatted file to stdout. The filename of the current buffer can be passed as argument by using the %{buffer_name} expansion variable.'';
      default = null;
      type = nullOr (submodule {
        options = {
          command = mkOption {
            type = nullOr str;
            default = null;
          };
          args = mkOption {
            type = nullOr (listOf str);
            default = null;
          };
        };
      });
    };
    scope = mkOption {
      type = nullOr str;
      default = null;
      description = "A string like source.js that identifies the language. Currently, we strive to match the scope names used by popular TextMate grammars and by the Linguist library. Usually source.<name> or text.<name> in case of markup languages";
    };
    language-id = mkOption {
      default = null;
      type = nullOr str;
      description = "The language-id for language servers, checkout the table at TextDocumentItem for the right id";
    };
    injection-regex = mkOption {
      type = nullOr str;
      default = null;
      description = "regex pattern that will be tested against a language name in order to determine whether this language should be used for a potential language injection site.";
    };
    file-types = mkOption {
      type = nullOr (
        listOf (
          either str (submodule {
            options = {
              glob = mkOption {
                type = nullOr str;
                default = null;
                description = ''checks against the full path of a given file. Globs are standard Unix-style path globs (e.g. the kind you use in Shell) and can be used to match paths for a specific prefix, suffix, directory, etc. A { glob = "Makefile" } config would match files with the name Makefile, the { glob = ".git/config" } config would match config files in .git directories, and the { glob = ".github/workflows/*.yaml" } config would match any yaml files in .github/workflow directories. Note that globs should always use the Unix path separator / even on Windows systems; the matcher will automatically take the machine-specific separators into account. If the glob isn't an absolute path or doesn't already start with a glob prefix, */ will automatically be added to ensure it matches for any subdirectory.'';
              };
            };
          })
        )
      );
      default = null;
      description = ''The filetypes of the language, for example `["yml", "yaml"]`. See the file-type detection section below.'';
    };
    roots = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = "A set of marker files to look for when trying to find the workspace root. For example Cargo.lock, yarn.lock";
    };
    shebangs = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = ''The interpreters from the shebang line, for example ["sh", "bash"]'';
    };
    diagnostic-severity = mkOption {
      default = null;
      type = nullOr (enum [
        "error"
        "warning"
        "info"
        "hint"
      ]);
      description = "Minimal severity of diagnostic for it to be displayed.";
    };
    comment-token = mkOption {
      type = nullOr (either str (listOf str));
      default = null;
      description = ''The tokens to use as a comment token, either a single token "//" or an array ["//", "///", "//!"] (the first token will be used for commenting).'';
      apply = x: if builtins.isNull x then null else lib.toList x;
    };
    comment-tokens = mkOption {
      type = nullOr (either str (listOf str));
      default = null;
      description = ''The tokens to use as a comment token, either a single token "//" or an array ["//", "///", "//!"] (the first token will be used for commenting). Also configurable as comment-token for backwards compatibility.'';
      apply = x: if builtins.isNull x then null else lib.toList x;
    };
    block-comment-tokens =
      let
        blockAttrs = {
          options = {
            start = mkOption {
              type = nullOr str;
              default = null;
            };
            end = mkOption {
              type = nullOr str;
              default = null;
            };
          };
        };
      in
      mkOption {
        description = ''The start and end tokens for a multiline comment either an array or single table of { start = "/*", end = "*/"}. The first set of tokens will be used for commenting, any pairs in the array can be uncommented'';
        default = null;
        type = nullOr (either (submodule blockAttrs) (listOf (either str (submodule blockAttrs))));
      };
    indent = mkOption {
      description = ''The indent to use. Has sub keys unit () and tab-width ()'';
      default = null;
      type = nullOr (submodule {
        options = {
          unit = mkOption {
            default = null;
            type = nullOr str;
            description = ''the text inserted into the document when indenting; usually set to N spaces or "\t" for tabs'';
          };
          tab-width = mkOption {
            default = null;
            type = nullOr ints.unsigned;
            description = "the number of spaces rendered for a tab";
          };
        };
      });
    };
    language-servers = mkOption {
      type = nullOr (listOf (either str (attrsOf anything)));
      default = null;
      description = "The Language Servers used for this language.";
    };
    grammar = mkOption {
      type = nullOr str;
      description = "The tree-sitter grammar to use (defaults to the value of name)";
      default = null;
    };
    ## TODO soft-wrap	editor.softwrap
    text-width = mkOption {
      type = nullOr ints.unsigned;
      default = null;
      description = "Maximum line length. Used for the :reflow command and soft-wrapping if soft-wrap.wrap-at-text-width is set, defaults to editor.text-width";
    };
    rulers = mkOption {
      type = nullOr (listOf ints.unsigned);
      default = null;
      description = "Overrides the editor.rulers config key for the language.";
    };
    ## TODO path-completion	Overrides the editor.path-completion config key for the language.
    ## TODO workspace-lsp-roots	Directories relative to the workspace root that are treated as LSP roots. Should only be set in .helix/config.toml. Overwrites the setting of the same name in config.toml if set.
    persistent-diagnostic-sources = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = "An array of LSP diagnostic sources assumed unchanged when the language server resends the same set of diagnostics. Helix can track the position for these diagnostics internally instead. Useful for diagnostics that are recomputed on save.";
    };
  };
}
