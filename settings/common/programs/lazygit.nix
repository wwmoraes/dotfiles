{ pkgs
, lib
, ...
}: {
	home-manager.sharedModules = [
		{
			programs.lazygit = {
				enable = true;
				settings = {
					confirmOnQuit = false;
					disableStartupPopups = true;
					notARepository = "skip";
					quitOnTopLevelReturn = false;

					customCommands = [
						{
							key = "b";
							command = "tig blame -- {{.SelectedFile.Name}}";
							context = "files";
							description = "blame file at tree";
							output = "terminal";
						}
						{
							key = "b";
							command = "tig blame {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
							context = "commitFiles";
							description = "blame file at revision";
							output = "terminal";
						}
						{
							key = "B";
							command = "tig blame -- {{.SelectedCommitFile.Name}}";
							context = "commitFiles";
							description = "blame file at tree";
							output = "terminal";
						}
						{
							key = "D";
							command = "tig show {{.SelectedSubCommit.Sha}}";
							context = "subCommits";
							description = "Show commit diff";
							output = "terminal";
						}
						{
							key = "D";
							command = "tig show {{.SelectedLocalBranch.Name}}";
							context = "localBranches";
							description = "Show branch diff";
							output = "terminal";
						}
						{
							key = "D";
							command = "tig show {{.SelectedRemoteBranch.RemoteName}}/{{.SelectedRemoteBranch.Name}}";
							context = "remoteBranches";
							description = "Show branch diff";
							output = "terminal";
						}
						{
							key = "h";
							command = "tig {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
							context = "commitFiles";
							description = "Show file commit history";
							output = "terminal";
						}
						{
							key = "h";
							command = "tig -- {{.SelectedFile.Name}}";
							context = "files";
							description = "Show file commit history";
							output = "terminal";
						}
						{
							key = "M";
							command = "git mergetool {{ .SelectedFile.Name }}";
							context = "files";
							description = "Open file in git merge tool";
							loadingText = "opening git mergetool";
							output = "terminal";
						}
						{
							key = "Y";
							context = "global";
							description = "YOLO changes";
							command = "git commit --amend --all --no-edit && git push --force-with-lease";
							loadingText = "YOLO'ing...";
							prompts = [
								{
									type = "confirm";
									title = "YOLO!";
									body = "Are you sure you want to amend last commit and force-push it?";
								}
							];
						}
						{
							key = "<c-c>";
							context = "global";
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
											value ="";
											description ="no";
										}
										{
											value ="!";
											description ="YES";
										}
									];
								}
								{
									type ="input";
									title ="Commit summary";
									key ="Summary";
								}
							];
							command = pkgs.lib.local.foldString ''
								git commit
								--edit
								--message="${pkgs.lib.concatStrings [
									"{{- .Form.Type -}}"
									"{{- with .Form.Scope -}}"
									"({{ . }})"
									"{{- end -}}"
									"{{- .Form.Breaking -}}: {{ .Form.Summary -}}"
								]}"
							'';
							loadingText = "creating commit";
							description = "Commit changes using conventional messages";
							output = "terminal";
						}
					];
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
						allBranchesLogCmds = [(pkgs.lib.local.foldString ''
							git log
							--color
							--graph
							--pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
							--abbrev-commit
							--date=relative
							--
						'')];
						commit.signOff = false;
						overrideGpg = true;
						paging = {
							colorArg = "always";
							pager = pkgs.lib.local.foldString ''
								delta
								--dark
								--paging=never
								--line-numbers
								--hyperlinks
								--hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
							'';
						};
					};
					os = {
						edit = "hx -- '{{filename}}'";
						editAtLine = "hx -- '{{filename}}:{{line}}'";
						editAtLineAndWait = "hx -- '{{filename}}:{{line}}'";
						open = "hx -- '{{filename}}'";
						openDirInEditor = "hx -w '{{dir}}'";
					};
					# services = {
					#   "cbsp-abnamro@dev.azure.com" = "azuredevops:dev.azure.com";
					#   "git.us.aegon.com" = "github:git.us.aegon.com";
					# };
				};
			};
		}
	];
}
