{
  pkgs,
  ...
}:
{
  home.file = {
    "Library/Application Support/io.datasette.llm/default_model.txt" = {
      text = "github_copilot/gpt-4o";
    };
  };

  home.packages = [
    (pkgs.unstable.python312.withPackages (
      ps: with ps; [
        # keep-sorted start
        llm
        llm-github-copilot
        # keep-sorted end
      ]
    ))
  ];
}
