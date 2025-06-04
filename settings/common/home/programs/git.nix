{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.libossp_uuid # # uuid bin
    pkgs.libplist
    pkgs.tkdiff
  ];

  programs.git = rec {
    enable = true;

    aliases = import ./aliases.nix;

    attributes = [
      "*.bash diff=bash"
      "*.css diff=css"
      "*.html diff=html"
      "*.md diff=markdown"
      "*.plist diff=plist"
      "*.py diff=python"
      "*.rb diff=ruby"
      "*.rs diff=rust"
      "*.tex diff=tex"
    ];

    delta = {
      enable = true;
      options = {
        dark = true;
        light = false;
        line-numbers = true;
        navigate = true;
        syntax-theme = "base16-stylix";
        tabs = 2;
      };
      package = pkgs.delta;
    };

    extraConfig = {
      advice = {
        detachedHead = false;
        skippedCherryPicks = false;
      };
      am = {
        threeWay = true;
      };
      apply = {
        ignoreWhitespace = "change";
        whitespace = "fix";
      };
      branch = {
        sort = "-committerdate";
        autoSetupRebase = "always";
      };
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          commit = "green bold";
          frag = "magenta bold";
          meta = "yellow bold";
          new = "green bold";
          newMoved = "cyan";
          old = "red bold";
          oldMoved = "blue";
          whitespace = "red reverse";
        };
        diff-highlight = {
          newHighlight = "green bold 22";
          newNormal = "green bold";
          oldHighlight = "red bold 52";
          oldNormal = "red bold";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };
      column = {
        ui = "auto";
      };
      commit = {
        verbose = true;
      };
      core = {
        commentChar = lib.mkDefault "auto";
        editor = "hx";
        ## git's simple IPC does not provide stdin and stdout, which causes tools that
        ## poorly handle their absence to crash; a notable example is yamllint
        # fsMonitor = true;
        # hooksPath = "${config.xdg.configHome}/git/hooks";
        ignoreCase = false;
        preComposeUnicode = true;
        untrackedCache = true;
      };
      credential = {
        helper = lib.mkDefault "osxkeychain";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        dstPrefix = "new/";
        guitool = "opendiff";
        mnemonicPrefix = true;
        renames = "copies";
        srcPrefix = "old/";
        plist = {
          textConv = "plistutil --sort --format xml --infile";
          cachetextconv = true;
          binary = true;
        };
      };
      difftool = {
        guiDefault = "auto";
        prompt = false;
        trustExitCode = true;
      };
      fetch = {
        all = true;
        fsckObjects = true;
        prune = true;
        pruneTags = true;
      };
      format = {
        coverFromDescription = "auto";
        coverLetter = "auto";
        from = true;
        notes = true;
        outputDirectory = "patches";
        signOff = true;
        thread = "shallow";
        useAutoBase = true;
      };
      gui = {
        pruneDuringFetch = true;
      };
      help = {
        autoCorrect = "prompt";
      };
      init = {
        defaultBranch = "main";
      };
      log = {
        date = "relative";
      };
      mailInfo = {
        scissors = true;
      };
      mailmap = {
        file = "${config.xdg.configHome}/git/mailmap";
      };
      merge = {
        autoStash = true;
        conflictStyle = "zdiff3";
        ff = "only";
        guitool = "opendiff";
        tool = "tkdiff";
      };
      mergetool = {
        hideResolved = true;
        prompt = false;
      };
      notes = {
        displayRef = "refs/notes/*";
        rewriteRef = "refs/notes/commits";
        commits = {
          mergeStrategy = "cat_sort_uniq";
        };
      };
      pager = {
        blame = lib.getExe delta.package;
        diff = lib.getExe delta.package;
      };
      protocol = {
        ## faster git server communication.
        ## like a LOT faster. https://opensource.googleblog.com/2018/05/introducing-git-protocol-version-2.html
        version = 2;
      };
      pull = {
        rebase = true;
        ff = true;
      };
      push = {
        autoSetupRemote = true;
        default = "simple";
        followTags = true;
        recurseSubmodules = "check";
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      receive = {
        fsckObjects = true;
      };
      remote = {
        origin = {
          fetch = "+refs/notes/*:refs/notes/*";
        };
      };
      rerere = {
        autoUpdate = true;
        enabled = true;
      };
      safe = {
        directory = "*";
      };
      sendEmail = {
        annotate = "yes";
        chainReplyTo = false;
      };
      smartGit = {
        submodule = {
          fetchAlways = false;
          initializeNew = true;
          update = true;
        };
      };
      stash = {
        showPatch = true;
      };
      tag = {
        sort = "version:refname";
      };
      ## https://git-scm.com/docs/git-interpret-trailers
      trailer = {
        ack = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Acknowledged-by";
        };
        coauthor = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Co-authored-by";
        };
        helper = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Helped-by";
        };
        mentor = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Mentored-by";
        };
        patch-stack = {
          cmd = "uuid -v 4 ; :";
          ifExists = "doNothing";
          ifMissing = "add";
          key = "ps-id";
        };
        reporter = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Reported-by";
        };
        requester = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Requested-by";
        };
        reviewer = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Reviewed-by";
        };
        signer = {
          cmd = "git author";
          ifExists = "replace";
          ifMissing = "add";
          key = "Signed-off-by";
        };
        tester = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Tested-by";
        };
        thanks = {
          cmd = "git author";
          ifExists = "addIfDifferent";
          ifMissing = "add";
          key = "Thanks-to";
        };
      };
      transfer = {
        fsckObjects = true;
      };
      url = {
        # "git://gist.github.com/".insteadOf = "gist:";
        "git@github.com:".insteadOf = "git://github";
        "git@gist.github.com:".insteadOf = [
          "gist:"
          "https://gist.github.com/"
        ];
      };
      user = {
        useConfigOnly = true;
      };
    };

    ignores = [
      "*~" # # backup files
      ".DS_Store" # # MacOS folder view settings
      ".Spotlight-V100" # # MacOS search index
      ".Trashes" # # MacOS trash bin
      "._*" # # MacOS thumbnail cache
      ".direnv"
      ".tmp"
      "Desktop.ini" # # Windows folder view settings
      "Thumbs.db" # # Windows thumbnail cache
      "tmp"
    ];

    lfs = {
      enable = true;
    };

    signing = {
      format = "openpgp";
      signByDefault = true;
      signer = lib.getExe config.programs.gpg.package;
    };
  };

  xdg.configFile = lib.mkIf config.programs.git.enable {
    "git/hooks/commit-msg" = {
      executable = true;
      text = ''
        #!${pkgs.runtimeShell}

        git interpret-trailers --trailer signer --trailer patch-stack --trim-empty "$1" | sponge "$1"
      '';
    };
  };
}
