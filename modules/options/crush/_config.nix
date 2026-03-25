{ lib, ... }:
let
  inherit (lib) mkOption types;
in
with types;
submodule {
  options = {
    "$schema" = mkOption {
      default = null;
      type = nullOr str;
    };
    models = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = lazyAttrsOf raw;
        options = {
          max_tokens = mkOption {
            default = null;
            type = nullOr int;
            description = "Maximum number of tokens for model responses";
          };
          top_p = mkOption {
            default = null;
            type = nullOr number;
            description = "Top-p (nucleus) sampling parameter";
          };
          top_k = mkOption {
            default = null;
            type = nullOr int;
            description = "Top-k sampling parameter";
          };
          frequency_penalty = mkOption {
            default = null;
            type = nullOr number;
            description = "Frequency penalty to reduce repetition";
          };
          presence_penalty = mkOption {
            default = null;
            type = nullOr number;
            description = "Presence penalty to increase topic diversity";
          };
          model = mkOption {
            default = null;
            type = nullOr str;
            description = "The model ID as used by the provider API";
          };
          reasoning_effort = mkOption {
            default = null;
            type = nullOr (enum [
              "low"
              "medium"
              "high"
            ]);
            description = "Reasoning effort level for OpenAI models that support it";
          };
          provider = mkOption {
            default = null;
            type = nullOr str;
            description = "The model provider ID that matches a key in the providers config";
          };
          think = mkOption {
            default = null;
            type = nullOr bool;
            description = "Enable thinking mode for Anthropic models that support reasoning";
          };
          temperature = mkOption {
            default = null;
            type = nullOr number;
            description = "Sampling temperature";
          };
          provider_options = mkOption {
            default = null;
            type = nullOr attrs;
          };
        };
      });
    };
    providers = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = lazyAttrsOf raw;
        options = {
          system_prompt_prefix = mkOption {
            default = null;
            type = nullOr str;
            description = "Custom prefix to add to system prompts for this provider";
          };
          models = mkOption {
            default = [ ];
            type = listOf raw # TODO add JSON Schema "" support
            ;
            description = "List of models available from this provider";
          };
          id = mkOption {
            default = null;
            type = nullOr str;
            description = "Unique identifier for the provider";
          };
          extra_headers = mkOption {
            default = null;
            type = nullOr attrs;
          };
          name = mkOption {
            default = null;
            type = nullOr str;
            description = "Human-readable name for the provider";
          };
          type = mkOption {
            default = "openai";
            type = enum [
              "openai"
              "openai-compat"
              "anthropic"
              "gemini"
              "azure"
              "vertexai"
            ];
            description = "Provider type that determines the API format";
          };
          api_key = mkOption {
            default = null;
            type = nullOr str;
            description = "API key for authentication with the provider";
          };
          oauth = mkOption {
            default = null;
            type = nullOr (submodule {
              options = {
                access_token = mkOption {
                  default = null;
                  type = nullOr str;
                };
                refresh_token = mkOption {
                  default = null;
                  type = nullOr str;
                };
                expires_in = mkOption {
                  default = null;
                  type = nullOr int;
                };
                expires_at = mkOption {
                  default = null;
                  type = nullOr int;
                };
              };
            });
          };
          disable = mkOption {
            default = false;
            type = bool;
            description = "Whether this provider is disabled";
          };
          extra_body = mkOption {
            default = null;
            type = nullOr attrs;
          };
          base_url = mkOption {
            default = null;
            type = nullOr str;
            description = "Base URL for the provider's API";
          };
          provider_options = mkOption {
            default = null;
            type = nullOr attrs;
          };
        };
      });
    };
    mcp = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = lazyAttrsOf raw;
        options = {
          type = mkOption {
            default = "stdio";
            type = enum [
              "stdio"
              "sse"
              "http"
            ];
            description = "Type of MCP connection";
          };
          headers = mkOption {
            default = null;
            type = nullOr attrs;
          };
          command = mkOption {
            default = null;
            type = nullOr str;
            description = "Command to execute for stdio MCP servers";
          };
          env = mkOption {
            default = null;
            type = nullOr attrs;
          };
          url = mkOption {
            default = null;
            type = nullOr str;
            description = "URL for HTTP or SSE MCP servers";
          };
          disabled = mkOption {
            default = false;
            type = bool;
            description = "Whether this MCP server is disabled";
          };
          disabled_tools = mkOption {
            default = [ ];
            type = listOf str;
            description = "List of tools from this MCP server to disable";
          };
          timeout = mkOption {
            default = 15;
            type = int;
            description = "Timeout in seconds for MCP server connections";
          };
          args = mkOption {
            default = [ ];
            type = listOf str;
            description = "Arguments to pass to the MCP server command";
          };
        };
      });
    };
    lsp = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = lazyAttrsOf raw;
        options = {
          args = mkOption {
            default = [ ];
            type = listOf str;
            description = "Arguments to pass to the LSP server command";
          };
          init_options = mkOption {
            default = null;
            type = nullOr attrs;
          };
          root_markers = mkOption {
            default = [ ];
            type = listOf str;
            description = "Files or directories that indicate the project root";
          };
          command = mkOption {
            default = null;
            type = nullOr str;
            description = "Command to execute for the LSP server";
          };
          timeout = mkOption {
            default = 30;
            type = int;
            description = "Timeout in seconds for LSP server initialization";
          };
          disabled = mkOption {
            default = false;
            type = bool;
            description = "Whether this LSP server is disabled";
          };
          env = mkOption {
            default = null;
            type = nullOr attrs;
          };
          filetypes = mkOption {
            default = [ ];
            type = listOf str;
            description = "File types this LSP server handles";
          };
          options = mkOption {
            default = null;
            type = nullOr attrs;
          };
        };
      });
    };
    options = mkOption {
      default = null;
      type = nullOr (submodule {
        options = {
          skills_paths = mkOption {
            default = [ ];
            type = listOf str;
            description = "Paths to directories containing Agent Skills (folders with SKILL.md files)";
          };
          tui = mkOption {
            default = null;
            type = nullOr (submodule {
              options = {
                diff_mode = mkOption {
                  default = null;
                  type = nullOr (enum [
                    "unified"
                    "split"
                  ]);
                  description = "Diff mode for the TUI interface";
                };
                completions = mkOption {
                  default = null;
                  type = nullOr (submodule {
                    options = {
                      max_depth = mkOption {
                        default = 0;
                        type = int;
                        description = "Maximum depth for the ls tool";
                      };
                      max_items = mkOption {
                        default = 1000;
                        type = int;
                        description = "Maximum number of items to return for the ls tool";
                      };
                    };
                  });
                };
                transparent = mkOption {
                  default = false;
                  type = bool;
                  description = "Enable transparent background for the TUI interface";
                };
                compact_mode = mkOption {
                  default = false;
                  type = bool;
                  description = "Enable compact mode for the TUI interface";
                };
              };
            });
          };
          data_directory = mkOption {
            default = ".crush";
            type = str;
            description = "Directory for storing application data (relative to working directory)";
          };
          disable_metrics = mkOption {
            default = false;
            type = bool;
            description = "Disable sending metrics";
          };
          disabled_tools = mkOption {
            default = [ ];
            type = listOf str;
            description = "List of built-in tools to disable and hide from the agent";
          };
          attribution = mkOption {
            default = null;
            type = nullOr (submodule {
              options = {
                trailer_style = mkOption {
                  default = "assisted-by";
                  type = enum [
                    "none"
                    "co-authored-by"
                    "assisted-by"
                  ];
                  description = "Style of attribution trailer to add to commits";
                };
                co_authored_by = mkOption {
                  default = null;
                  type = nullOr bool;
                  description = "Deprecated: use trailer_style instead";
                };
                generated_with = mkOption {
                  default = true;
                  type = bool;
                  description = "Add Generated with Crush line to commit messages and issues and PRs";
                };
              };
            });
          };
          debug_lsp = mkOption {
            default = false;
            type = bool;
            description = "Enable debug logging for LSP servers";
          };
          disable_auto_summarize = mkOption {
            default = false;
            type = bool;
            description = "Disable automatic conversation summarization";
          };
          context_paths = mkOption {
            default = [ ];
            type = listOf str;
            description = "Paths to files containing context information for the AI";
          };
          auto_lsp = mkOption {
            default = true;
            type = bool;
            description = "Automatically setup LSPs based on root markers";
          };
          disable_default_providers = mkOption {
            default = false;
            type = bool;
            description = "Ignore all default/embedded providers. When enabled";
          };
          progress = mkOption {
            default = true;
            type = bool;
            description = "Show indeterminate progress updates during long operations";
          };
          debug = mkOption {
            default = false;
            type = bool;
            description = "Enable debug logging";
          };
          disable_provider_auto_update = mkOption {
            default = false;
            type = bool;
            description = "Disable providers auto-update";
          };
          initialize_as = mkOption {
            default = "AGENTS.md";
            type = str;
            description = "Name of the context file to create/update during project initialization";
          };
        };
      });
    };
    permissions = mkOption {
      default = null;
      type = nullOr (submodule {
        options = {
          allowed_tools = mkOption {
            default = [ ];
            type = listOf str;
            description = "List of tools that don't require permission prompts";
          };
        };
      });
    };
    tools = mkOption {
      default = null;
      type = nullOr (submodule {
        options = {
          ls = mkOption {
            default = null;
            type = nullOr (submodule {
              options = {
                max_depth = mkOption {
                  default = 0;
                  type = int;
                  description = "Maximum depth for the ls tool";
                };
                max_items = mkOption {
                  default = 1000;
                  type = int;
                  description = "Maximum number of items to return for the ls tool";
                };
              };
            });
          };
          grep = mkOption {
            default = null;
            type = nullOr (submodule {
              options = {
                timeout = mkOption {
                  default = null;
                  type = nullOr int;
                  description = "Timeout for the grep tool call";
                };
              };
            });
          };
        };
      });
    };
  };
}
