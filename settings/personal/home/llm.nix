{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.ollama
  ];

  launchd.agents = {
    ollama = {
      enable = true;
      config = {
        EnvironmentVariables = {
          OLLAMA_HOST = "127.0.0.1:11434";
          OLLAMA_KEEP_ALIVE = "5m";
        };
        KeepAlive = false;
        Label = "dev.artero.ollama";
        ProcessType = "Adaptive";
        ProgramArguments = [
          "${lib.getExe pkgs.ollama}"
          "serve"
        ];
        RunAtLoad = false;
        Sockets.Listeners = {
          SockNodeName = "127.0.0.1";
          SockPassive = false;
          SockServiceName = "11434";
        };
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/dev.artero.ollama.server.err.log";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/dev.artero.ollama.server.out.log";
      };
    };
  };

  programs.helix = {
    extraPackages = [
      pkgs.unstable.helix-gpt
      pkgs.unstable.llama-cpp
      pkgs.unstable.lsp-ai
    ];

    languages = {
      language-server = {
        gpt = {
          command = "helix-gpt";
          args = [
            "--handler"
            "ollama"
            "--ollamaModel"
            "deepseek-coder-v2:16b"
            "--logFile"
            "$HOME/.cache/helix/gpt.log"
          ];
        };
        lsp-ai = {
          command = "lsp-ai";
          args = [ "--stdio" ];
          config = {
            actions = [
              {
                action_display_name = "Complete";
                model = "deepseek";
                parameters = {
                  max_context = 4096;
                  max_tokens = 4096;
                  messages = [
                    {
                      role = "user";
                      content = "{CODE}";
                    }
                  ];
                  system = ''
                    Instructions:
                    - You are an AI programming assistant.
                    - Your task is to complete code snippets.
                    - The user's cursor position is marked by <CURSOR>.
                    - Analyze the code context and the cursor position.
                    - Provide your chain of thought reasoning, written out in great detail as comments. Include thoughts about the cursor position, what needs to be completed, and any necessary formatting.
                    - Determine the appropriate code to complete the current thought, including finishing partial words or lines.
                    - Replace <CURSOR> with the necessary code, ensuring proper formatting and line breaks.

                    Rules:
                    - Ensure that your completion fits within the language context of the provided code snippet (e.g., Python, JavaScript, Rust, Go).
                    - Your response should always include both the reasoning and the answer. Pay special attention to completing partial words or lines before adding new lines of code.
                    - Only respond with code and/or comments.
                    - If the cursor is within a comment, complete the comment meaningfully.
                    - Handle ambiguous cases by providing the most contextually appropriate completion.
                    - Be consistent with your responses.
                  '';
                };
              }
              {
                action_display_name = "Refactor";
                model = "deepseek";
                parameters = {
                  max_context = 4096;
                  max_tokens = 4096;
                  messages = [
                    {
                      role = "user";
                      content = "{SELECTED_TEXT}";
                    }
                  ];
                  system = ''
                    Instructions:
                    - You are an AI programming assistant specializing in code refactoring.
                    - Your task is to analyze the given code snippet and provide a refactored version.
                    - Identify areas for improvement, such as code efficiency, readability, or adherence to best practices.
                    - Provide your chain of thought reasoning, written out as comments. Include your analysis of the current code and explain your refactoring decisions.
                    - Rewrite the entire code snippet with your refactoring applied.

                    Rules:
                    - Ensure that your completion fits within the language context of the provided code snippet (e.g., Python, JavaScript, Rust, Go).
                    - Your response should always include both the reasoning and the refactored code.
                    - Only respond with code and/or comments.
                    - If the cursor is within a comment, complete the comment meaningfully.
                    - Handle ambiguous cases by providing the most contextually appropriate completion.
                    - Be consistent with your responses.
                  '';
                };
              }
            ];
            chat = [
              {
                action_display_name = "Chat";
                model = "deepseek";
                trigger = "!C";
                parameters = {
                  max_context = 4096;
                  max_tokens = 1024;
                  system = "You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately";
                };
              }
              {
                action_display_name = "Chat with context";
                model = "deepseek";
                trigger = "!CC";
                parameters = {
                  max_context = 4096;
                  max_tokens = 1024;
                  system = ''
                    You are a code assistant chatbot. The user will ask you for assistance coding
                    and you will do your best to answer succinctly and accurately given the code
                    context:

                    {CONTEXT}
                  '';
                };
              }
            ];
            completion = {
              model = "deepseek";
              parameters = {
                fim = {
                  start = "<fim_prefix>";
                  middle = "<fim_suffix>";
                  end = "<fim_middle>";
                };
                max_context = 4096;
                max_tokens = 4096;
                system = ''
                  Instructions:
                  - You are an AI programming assistant.
                  - Your task is to complete code snippets.
                  - The user's cursor position is marked by <CURSOR>.
                  - Analyze the code context and the cursor position.
                  - Provide your chain of thought reasoning, written out in great detail as comments. Include thoughts about the cursor position, what needs to be completed, and any necessary formatting.
                  - Determine the appropriate code to complete the current thought, including finishing partial words or lines.
                  - Replace <CURSOR> with the necessary code, ensuring proper formatting and line breaks.

                  Rules:
                  - Ensure that your completion fits within the language context of the provided code snippet (e.g., Python, JavaScript, Rust, Go).
                  - Your response should always include both the reasoning and the answer. Pay special attention to completing partial words or lines before adding new lines of code.
                  - Only respond with code and/or comments.
                  - If the cursor is within a comment, complete the comment meaningfully.
                  - Handle ambiguous cases by providing the most contextually appropriate completion.
                  - Be consistent with your responses.
                '';
              };
            };
            memory.vector_store = {
              data_type = "f32";
              embedding_model = {
                type = "ollama";
                model = "deepseek-coder-v2:16b";
                prefix = {
                  retrieval = "search_query";
                  storage = "search_document";
                };
              };
              splitter.type = "tree_sitter";
            };
            models.deepseek = {
              type = "ollama";
              model = "deepseek-coder-v2:16b";
            };
          };
        };
      };
      # language = [
      #   {
      #     name = "go";
      #     language-servers = ["gpt"];
      #   }
      # ];
    };
  };
}
