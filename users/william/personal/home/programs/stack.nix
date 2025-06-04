## TODO create module to manage stack
{
  pkgs,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
in
{
  # home.packages = [
  #   pkgs.stack
  # ];

  home.file.".stack/config.yaml" = {
    source = yamlFormat.generate "stack-config.yaml" {
      ## http://docs.haskellstack.org/en/stable/yaml_configuration/
      # build = {
      #   haddock = true;
      #   test = true;
      #   test-arguments = {
      #     additional-args = [
      #       "--color"
      #       "--diff"
      #       "--failure-report=.stack-work/hspec-failures"
      #       "--pretty"
      #       "--randomize"
      #       "--rerun"
      #       "--rerun-all-on-success"
      #       "--times"
      #       "--unicode"
      #     ];
      #     coverage = true;
      #     rerun-tests = false;
      #   };
      # };
      default-template = "wwmoraes/default";
      ## https://docs.haskellstack.org/en/stable/yaml_configuration/#templates
      templates = {
        scm-init = "git";
        params = {
          author-name = "William Artero";
          author-email = "haskell@artero.dev";
          github-username = "wwmoraes";
          category = "Command Line";
          license = "MIT";
        };
      };
    };
  };
}
