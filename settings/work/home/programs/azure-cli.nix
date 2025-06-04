{
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.unstable.azure-cli.withExtensions [
      pkgs.unstable.azure-cli-extensions.azure-devops
    ])
  ];

  home.sessionVariables = {
    # AZURE_CORE_ONLY_SHOW_ERRORS = "1";
    # AZURE_DEVOPS_DEFAULTS_ORGANIZATION = "https://dev.azure.com/cbsp-abnamro";
    # AZURE_DEVOPS_DEFAULTS_PROJECT = "GRD0001007";
  };
}
