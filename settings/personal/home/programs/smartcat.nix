{
  pkgs,
  ...
}:
let
  toml = pkgs.formats.toml { };
in
{
  home.packages = [
    pkgs.smartcat
  ];

  xdg.configFile = {
    "smartcat/.api_configs.toml" = {
      source = toml.generate "smartcat-api-configs.toml" {
        ollama = {
          default_model = "deepseek-r1:latest";
          timeout_seconds = 180;
          url = "http://localhost:11434/api/chat";
        };
      };
    };
    "smartcat/prompts.toml" = {
      source = toml.generate "smartcat-prompts.toml" {
        default = {
          api = "ollama";
          model = "qwen2.5-coder:7b-instruct-q5_K_M";
          messages = [
            {
              role = "system";
              content = ''
                You are an expert programmer and a shell master. You value code
                efficiency and clarity above all things. What you write will be
                piped in and out of cli programs so you do not explain anything
                unless explicitly asked to. Never write ``` around your answer,
                provide only the result of the task you are given. Preserve
                input formatting.
              '';
            }
          ];
        };
        empty = {
          api = "ollama";
          messages = [ ];
        };
        nix = {
          api = "ollama";
          model = "qwen2.5-coder:7b-instruct-q5_K_M";
          messages = [
            {
              role = "system";
              content = ''
                You are an expert software engineer and a Nix master that
                leverages nix expressions for environment and development
                configuration. You use the Nixpkgs library of derivations and
                functions where applicable and whenever possible. What you write
                will be piped in and out of cli programs so you do not explain
                anything unless explicitly asked to. Never write ``` around
                your answer, provide only the result of the task you are given.
                Preserve input formatting.
              '';
            }
          ];
        };
        review = {
          api = "ollama";
          default_model = "llama2-uncensored:7b-chat-q6_K";
          messages = [
            {
              role = "system";
              content = ''
                You are an expert writing reviewer, knowledgeable on how to
                write good essays, papers and articles. Your job is to point
                out where to improve the writing for better readability. You may
                suggest changes on the topic if it improves its credibility and
                eases understanding. Do not change the content directly; instead
                provide notes on what could change in the form of comments or
                other mechanisms that clearly separates your notes from the
                original content. Reviewed content should have a Flesch–Kincaid
                readability store above 60 whenever possible.
              '';
            }
            {
              role = "user";
              content = ''
                Review the following content.

                #[<input>]
              '';
            }
          ];
        };
      };
    };
  };
}
