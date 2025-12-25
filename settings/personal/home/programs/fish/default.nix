{
  programs.fish = {
    shellAliases = {
      brew = "op plugin run -- brew";
      cachix = "op plugin run -- cachix";
      doctl = "op plugin run -- doctl";
      gh = "op plugin run -- gh";
      pulumi = "op plugin run -- pulumi";
    };
  };
}
