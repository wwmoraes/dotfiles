{
  flake.modules.generic.william = {
    programs = {
      # keep-sorted start
      less.enable = true;
      # keep-sorted end
    };
  };

  flake.modules.darwin.william = {
    programs = {
      # keep-sorted start
      _1password-gui.enable = true;
      _1password.enable = true;
      fish.enable = true;
      # keep-sorted end
    };

    services = {
      # keep-sorted start
      littlesnitch.enable = true;
      # keep-sorted end
    };
  };

  flake.modules.homeManager.william = {
    editorconfig.enable = true;

    programs = {
      # keep-sorted start
      aichat.enable = true;
      bat.enable = true;
      crush.enable = true;
      delta.enable = true;
      dircolors.enable = true;
      fd.enable = true;
      fish.enable = true;
      fzf.enable = true;
      gh.enable = true;
      gh.gitCredentialHelper.enable = false;
      git-ps.enable = true;
      git.enable = true;
      go.enable = true;
      helix.enable = true;
      jq.enable = true;
      kitty.enable = true;
      lazygit.enable = true;
      librewolf.enable = false;
      man.enable = true;
      nap.enable = true;
      powerline-go.enable = true;
      readline.enable = true;
      ssh.enable = true;
      texlive.enable = true;
      tree.enable = true;
      zellij.enable = true;
      # keep-sorted end
    };
  };
}
