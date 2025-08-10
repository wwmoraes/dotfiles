{
  config,
  lib,
  pkgs,
  ...
}:
let
  deltaBin = lib.getExe config.programs.git.delta.package;
  hxBin = lib.getExe config.programs.helix.package;
  tigBin = lib.getExe pkgs.tig;
in
{
  programs.lazygit = {
    enable = true;
    settings = {
      confirmOnQuit = false;
      customCommands = [
        {
          command = "git add --intent-to-add {{.SelectedFile.Name}}";
          context = "files";
          description = "Record intent to add new file";
          key = "N";
          output = "log";
        }
        {
          command = "${tigBin} blame -- {{.SelectedFile.Name}}";
          context = "files";
          description = "Blame file at tree";
          key = "b";
          output = "terminal";
        }
        {
          command = "${tigBin} blame {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
          context = "commitFiles";
          description = "Blame file at revision";
          key = "b";
          output = "terminal";
        }
        {
          command = "${tigBin} blame -- {{.SelectedCommitFile.Name}}";
          context = "commitFiles";
          description = "Blame file at tree";
          key = "B";
          output = "terminal";
        }
        {
          command = "${tigBin} show {{.SelectedSubCommit.Sha}}";
          context = "subCommits";
          description = "Show commit diff";
          key = "D";
          output = "terminal";
        }
        {
          command = "${tigBin} show {{.SelectedLocalBranch.Name}}";
          context = "localBranches";
          description = "Show branch diff";
          key = "D";
          output = "terminal";
        }
        {
          command = "${tigBin} show {{.SelectedRemoteBranch.RemoteName}}/{{.SelectedRemoteBranch.Name}}";
          context = "remoteBranches";
          description = "Show branch diff";
          key = "D";
          output = "terminal";
        }
        {
          command = "${tigBin} {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
          context = "commitFiles";
          description = "Show file commit history";
          key = "h";
          output = "terminal";
        }
        {
          command = "${tigBin} -- {{.SelectedFile.Name}}";
          context = "files";
          description = "Show file commit history";
          key = "h";
          output = "terminal";
        }
        {
          command = "git mergetool {{ .SelectedFile.Name }}";
          context = "files";
          description = "Open file in git merge tool";
          key = "M";
          loadingText = "opening git mergetool";
          output = "terminal";
        }
        {
          command = "git backup";
          context = "global";
          description = "Backup HEAD to user's remote trunk";
          key = "B";
          loadingText = "pushing...";
          output = "logWithPty";
        }
        {
          command = "git restore";
          context = "global";
          description = "Restore HEAD from user's remote trunk";
          key = "<c-r>";
          loadingText = "pulling...";
          output = "logWithPty";
          prompts = [
            {
              type = "confirm";
              title = "Restore";
              body = "Are you sure you want to pull your trunk patches into your current branch?";
            }
          ];
        }
        {
          command = "git commit --amend --all --no-edit && git push --force-with-lease";
          context = "global";
          description = "YOLO changes";
          key = "Y";
          loadingText = "YOLO'ing...";
          output = "logWithPty";
          prompts = [
            {
              type = "confirm";
              title = "YOLO!";
              body = "Are you sure you want to amend last commit and force-push it?";
            }
          ];
        }
        {
          context = "global";
          key = "<c-c>";
          prompts = [
            {
              type = "menu";
              title = "What kind of change is it?";
              key = "Type";
              options = [
                {
                  name = "build";
                  description = "build system or external dependencies (scripts, tasks, etc)";
                  value = "build";
                }
                {
                  name = "chore";
                  description = "miscellaneous (does not affect any other type)";
                  value = "chore";
                }
                {
                  name = "ci";
                  description = "CI-related configuration files and scripts";
                  value = "ci";
                }
                {
                  name = "docs";
                  description = "documentation-only updates";
                  value = "docs";
                }
                {
                  name = "feat";
                  description = "new feature";
                  value = "feat";
                }
                {
                  name = "fix";
                  description = "bug fix";
                  value = "fix";
                }
                {
                  name = "perf";
                  description = "performance improvement";
                  value = "perf";
                }
                {
                  name = "refactor";
                  description = "restructures logic (neither fixes a bug nor adds a feature)";
                  value = "refactor";
                }
                {
                  name = "revert";
                  description = "restores a previous state";
                  value = "revert";
                }
                {
                  name = "style";
                  description = "white-space, formatting, missing semi-colons, etc";
                  value = "style";
                }
                {
                  name = "test";
                  description = "adds missing tests or corrects existing tests";
                  value = "test";
                }
              ];
            }
            {
              type = "input";
              title = "Is there a scope?";
              key = "Scope";
              initialValue = "";
            }
            {
              type = "menu";
              title = "Is it a breaking change?";
              key = "Breaking";
              options = [
                {
                  value = "";
                  description = "no";
                }
                {
                  value = "!";
                  description = "YES";
                }
              ];
            }
            {
              type = "input";
              title = "Commit summary";
              key = "Summary";
            }
          ];
          command = pkgs.lib.local.foldString ''
            git commit
            --edit
            --message="${
              pkgs.lib.concatStrings [
                "{{- .Form.Type -}}"
                "{{- with .Form.Scope -}}"
                "({{ . }})"
                "{{- end -}}"
                "{{- .Form.Breaking -}}: {{ .Form.Summary -}}"
              ]
            }"
          '';
          loadingText = "creating commit";
          description = "Commit changes using conventional messages";
          output = "terminal";
        }
      ];
      disableStartupPopups = true;
      git = {
        autoFetch = false;
        branchLogCmd = pkgs.lib.local.foldString ''
          git log
          --color
          --graph
          --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
          --abbrev-commit
          --date=relative {{branchName}}
          --
        '';
        allBranchesLogCmds = [
          (pkgs.lib.local.foldString ''
            git log
            --color
            --graph
            --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
            --abbrev-commit
            --date=relative
            --
          '')
        ];
        commit.signOff = false;
        mainBranches = [
          "master"
          "main"
        ];
        overrideGpg = true;
        paging = {
          colorArg = "always";
          pager = pkgs.lib.local.foldString ''
            ${deltaBin}
            --dark
            --paging=never
            --line-numbers
            --hyperlinks
            --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
          '';
        };
        # skipHookPrefix = "fixup!";
      };
      gui = {
        authorColors = {
          "*" = "#8a2be2";
          "GitHub Actions" = "#edf3fb";
          "William Artero" = "#2cbdff";
        };
        branchColorPatterns = {
          "user/.+/trunk" = "#EB4511";
          main = "#1BE7FF";
          master = "#1BE7FF";
          trunk = "#EB4511";
        };
        customIcons = {
          filenames = { };
          extensions = {
            ".bash" = {
              color = "#3DA238";
              icon = ""; # e760
            };
            ".fish" = {
              color = "#3DA238";
              icon = "󰈺"; # f023a
            };
            ".go" = {
              color = "#69CAFD";
              icon = ""; # e65e
            };
            ".gotmpl" = {
              color = "#69CAFD";
              icon = "󰅩"; # f0169
            };
            ".js" = {
              color = "#F4DB19";
              icon = ""; # e60c
            };
            ".json" = {
              color = "#FF9900";
              icon = ""; # e80b
            };
            ".nix" = {
              color = "#5AADE2";
              icon = ""; # e843
            };
            ".sh" = {
              color = "#3DA238";
              icon = ""; # e691
            };
            ".ts" = {
              color = "#2761B8";
              icon = ""; # e628
            };
          };
        };
        nerdFontsVersion = "3";
        tabWidth = 2;
      };
      notARepository = "skip";
      os = {
        edit = "${hxBin} -- '{{filename}}'";
        editAtLine = "${hxBin} -- '{{filename}}:{{line}}'";
        editAtLineAndWait = "${hxBin} -- '{{filename}}:{{line}}'";
        open = "${hxBin} -- '{{filename}}'";
        openDirInEditor = "${hxBin} -w '{{dir}}'";
      };
      quitOnTopLevelReturn = false;
      services = {
        "cbsp-abnamro@dev.azure.com" = "azuredevops:dev.azure.com";
        # "git.us.aegon.com" = "github:git.us.aegon.com";
      };
    };
  };
}
