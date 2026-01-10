{
  flake.modules.homeManager.development =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
    in
    {
      home.packages = [
        pkgs.libossp_uuid # uuid bin
        # pkgs.p4v # TODO test p4v
      ];

      programs.git = {
        enable = true;

        attributes = [
          "* text=auto" # fallback; this is best set on every repository
          "*.css diff=css"
          "*.html diff=html"
          "*.py diff=python"
          "*.rb diff=ruby"
          "*.rs diff=rust"
          "*.tex diff=tex"
        ];

        settings = {
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
            helper = lib.mkMerge [
              (lib.mkBefore [
                "cache --timeout 28800"
              ])
              (lib.optional isDarwin (lib.getExe' config.programs.git.package "git-credential-osxkeychain"))
              (lib.optional isLinux (lib.getExe' config.programs.git.package "git-credential-libsecret"))
              # (lib.mkAfter [
              #   (lib.getExe pkgs.git-credential-oauth) # TODO https://github.com/hickford/git-credential-oauth
              # ])
            ];
          };
          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            dstPrefix = "new/";
            mnemonicPrefix = true;
            renames = "copies";
            srcPrefix = "old/";
          };
          difftool = {
            guiDefault = "auto";
            prompt = false;
            trustExitCode = true;
          };
          fetch = {
            all = true;
            fsckObjects = true;
            negotiationAlgorithm = "consecutive";
            prune = true;
            pruneTags = true;
            writeCommitGraph = true;
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
          grep = {
            lineNumber = true;
            patternType = "perl";
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
          instaweb = {
            httpd = lib.getExe pkgs.lighttpd;
            local = true;
            port = 6178;
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
            # guitool = "p4v";
            renormalize = true;
            # tool = "vimdiff2"; # TODO find alternative to vimdiff
          };
          mergetool = {
            hideResolved = true;
            prompt = false;
          };
          notes = {
            displayRef = "refs/notes/commits";
            rewriteRef = "refs/notes/commits";
            commits = {
              mergeStrategy = "cat_sort_uniq";
            };
          };
          # pager = {
          #   blame = lib.getExe config.programs.delta.package;
          #   diff = lib.getExe config.programs.delta.package;
          # };
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
            "git@github.com:".insteadOf = "git://github";
            "git@gist.github.com:".insteadOf = [
              "gist:"
              "https://gist.github.com/"
            ];
          };
          user = {
            useConfigOnly = true;
          };
          web = {
            browser = "open";
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
    };

  flake.modules.homeManager.development'personal = {
    programs.git.settings.push.negotiate = true;
  };

  flake.modules.homeManager.william'work = {
    programs.git.includes =
      map
        (url: {
          contents = rec {
            author = {
              inherit (user) email;
            };
            committer = {
              inherit (user) email;
            };
            user = {
              email = "william.moraes.artero@nl.abnamro.com";
              handle = "artero";
            };
          };
          condition = "hasconfig:remote.*.url:${url}";
        })
        [
          "https://cbsp-abnamro@dev.azure.com/**"
          "https://p-bitbucket.nl.eu.abnamro.com:7999/**"
        ];
  };
}
