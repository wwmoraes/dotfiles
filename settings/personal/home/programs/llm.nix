{
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.python3.withPackages (
      ps: with ps; [
        # keep-sorted start
        llm
        llm-ollama
        # keep-sorted end
      ]
    ))
  ];
}
