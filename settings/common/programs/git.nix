{ config
, pkgs
, lib
, ...
}: {
	environment.systemPackages = [
		pkgs.gh
		pkgs.tig
		pkgs.tkdiff
		pkgs.unstable.git-ps-rs
		pkgs.unstable.lazygit
	];

	home-manager.sharedModules = [
		({ config, darwinConfig, ... }: {
			programs.git = rec {
				enable = true;

				aliases = {
					git = "!exec git"; # Needed for piping
					amend = "commit --amend --all --no-edit";
					co = "checkout";
					count = ''!f() { git rev-list --left-right --count HEAD...$1 | sed 's/\t/↑↓/'; }; f'';
					discard = "checkout --";
					head = "log --pretty=oneline --show-signature HEAD^..HEAD";
					local-prune = ''!git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "', $1); print $1}'); do git branch -D $branch; done'';
					nuke = "reset --hard";
					pick = "cherry-pick";
					please = "push --force-with-lease";
					r = "rebase --autosquash";
					ra = "rebase --abort";
					rc = "rebase --continue";
					resign = "rebase --exec 'git commit --amend --no-edit --no-verify --gpg-sign' --interactive";
					ri = "rebase --autosquash -i";
					rr = "rebase --autosquash --root";
					s = "status";
					scrap = "reset --hard HEAD^";
					uncommit = "reset --mixed HEAD~";
					unstage = "reset -q HEAD --";
					unwind = "reset --soft HEAD^";
					yolo = "push --force";
					c = "commit -am";
					lg = ''log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --'';
					seek-n-blame = ''!f() { git blame $(git log --pretty=%H --diff-filter=AM -1 -- "$1") -- "$1"; }; f'';
					who-deleted = ''!f() { git show -s --pretty=medium $(git log --pretty=%H -1 --diff-filter=D -- "$1"); }; f'';
					last-deleted = ''!f() { git log --pretty=%H -''${1:-1} --diff-filter=D | xargs -n1 git diff-tree --no-commit-id --name-only --diff-filter=D -r | sort -u; }; f'';
					d = ''!"git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat --color-words"'';
					fix = "!git diff --name-only --diff-filter=U | ifne xargs $EDITOR";
					fixup = ''!sh -c 'REV=$(git rev-parse $1) && git commit --fixup $@ && git rebase -i --autosquash $REV^' -'';
					fixit = ''!f() { git commit --fixup=$1; GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash $1~1; }; f'';
					fixall = ''!f() { COUNT=$(git rev-list --left-right --count $(git branch --show-current)...$(git rev-parse --abbrev-ref --symbolic-full-name @{u}) | xargs | cut -d' ' -f1); git rebase --autosquash HEAD~$COUNT; }; f'';
					reverse = "revert HEAD";
					nevermind = ''!git reset --hard HEAD && git clean -d -f'';
					graph = ''log --graph -10 --branches --remotes --tags  --format=format:'%Cgreen%h %Creset• %<(75,trunc)%s (%cN, %cr) %Cred%d' --date-order'';
					precommit = "diff --cached --diff-algorithm=minimal -w";
					ls = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]%Creset" --decorate'';
					ll = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]%Creset" --decorate --numstat'';
					lnc = ''log --pretty=format:"%h\\ %s\\ [%cn]"'';
					lds = ''log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]%Creset" --decorate --date=short'';
					le = "log --oneline --decorate";
					filelog = "log -u";
					fl = "log -u";
					dl = ''!git ll -1'';
					dlc = "diff --cached HEAD^";
					diffunc = "diff --cached";
					dr  = ''!f() { git diff "$1"^.."$1"; }; f'';
					lc  = ''!f() { git ll "$1"^.."$1"; }; f'';
					diffr  = ''!f() { git diff "$1"^.."$1"; }; f'';
					f = ''!git ls-files | grep -i'';
					fblame = ''!git ls-files | fzf -m --preview 'git blame --color-lines {}' | ifne xargs -n1 git blame'';
					find-deleted = ''!git log --diff-filter=D --summary | grep delete | cut -d' ' -f5- | sort -h'';
					cat-deleted = ''!f() { git cat-file -p "$(git log --pretty=%H --diff-filter=AM -1 -- "$1"):$1"; }; f'';
					grep = "grep -Ii";
					gr = "grep -Ii";
					gra = ''!f() { A=$(pwd) && TOPLEVEL=$(git rev-parse --show-toplevel) && cd $TOPLEVEL && git grep --full-name -In $1 | xargs -I{} echo $TOPLEVEL/{} && cd $A; }; f'';
					lasttag = "describe --tags --abbrev=0";
					lt = "describe --tags --abbrev=0";
					short-recent = ''for-each-ref --count=25 --sort=committerdate refs/heads/ --format="%(refname:short)"'';
					fadd = ''!git ls-files -m -o --exclude-standard | fzf --print0 -0 -m --preview 'git diff --color=always {}' --preview-window=down:10:wrap | xargs -0 -t -o git add --all'';
					fco = ''!git branch -a | awk '$1 == \"*\" {system(\"tput setaf 3\");print $2;system(\"tput sgr0\");next};{print $1}' | fzf --ansi | sed 's|^remotes/|--track |' | xargs -t git checkout'';
					fdel = ''!git branch -a | awk '$1 == \"*\" {system(\"tput setaf 3\");print $2;system(\"tput sgr0\");next};{print $1}' | fzf --ansi -m | awk '$0 ~ /^remotes/ {print \"push origin --delete\",$0;next}{print \"branch -D\",$0}' | sed 's|remotes/origin/||g' | ifne xargs -L 1 git'';
					ffix = ''!HASH=`git log --pretty=oneline | head -n 100 | fzf` && git fixit `echo ''${HASH} | awk '{ print $1 }'`'';
					frebase = ''!HASH=`git log --pretty=oneline | head -n 100 | fzf` && git rebase -i `echo ''${HASH} | awk '{ print $1 }'`^'';
					fed = ''!FILES=`git status -s | awk '{ print $2 }' | fzf -x -m` && code ''${FILES}'';
					fedconflicts = ''!FILES=`git status -s | grep '^[UMDA]\\{2\\} ' | awk '{ print $2 }' | fzf -x -m` && code ''${FILES}'';
					fgrep = ''!sh -c 'FILES=`git grep -l -A 0 -B 0 $1 $2 | fzf -x -m` && code `echo ''${FILES} | cut -d':' -f1 | xargs`' -'';
					fedlog = ''!HASH=`git log --pretty=oneline | head -n 50 | fzf` && HASHZ=`echo ''${HASH} | awk '{ print $1 }'` && FILES=`git show --pretty='format:' --name-only $HASHZ | grep -v -e '^$' | fzf -x -m` && code ''${FILES}'';
					freset = ''!HASH=`git log --pretty=oneline | head -n 50 | fzf` && git reset --soft `echo ''${HASH} | awk '{ print $1 }'`^'';
					purge = ''!f() { git filter-branch --force --index-filter \"git rm --cached --ignore-unmatch "$1"\" --prune-empty --tag-name-filter cat -- --all; }; f'';
					tgrep = ''!f() { A=$(pwd) && TOPLEVEL=$(git rev-parse --show-toplevel) && cd $TOPLEVEL && FILES=`git ls-files | fzf -m` && git rev-list --all --since=$2 | xargs -I% git grep $1 % -- $FILES; cd $A; }; f'';
					subrm = ''!f(){ git submodule deinit -f $1; git rm -rf $1 || true; rm -rf .git/modules/$1; git config -f .git/config --remove-section submodule.$1; git config -f .gitmodules --remove-section submodule.$1 || true; }; f'';
					authors = ''shortlog --summary --numbered --email --all'';
					fdiff = ''!f() { git diff --name-only --color=always $@ | fzf -m --ansi --preview \"git diff $@ --color=always -- {-1}\" | ifne xargs git diff $@ --; }; f'';
					review = ''!f() { BRANCHES=$(git branch --no-column --all --format=\"%(refname:lstrip=2)\") && BASE=$(echo $BRANCHES | tr ' ' '\n' | fzf --prompt='Base branch: ') && TARGET=$(echo $BRANCHES | tr ' ' '\n' | fzf --prompt='Target branch: ') && echo \"git fdiff $BASE..$TARGET\" && git fdiff $BASE..$TARGET; }; f'';
					author = ''!f() { CONTENT=$(test -n \"$1\" && git log --author=\"$1\" --pretty=\"%aN <%aE>\" -1); echo \"''${CONTENT:-$(git config user.name) <$(git config user.email)>}\"; }; f'';
					notes-push = "push origin 'refs/notes/*'";
				};

				attributes = [
					"*.json diff=json"
					"*.plist diff=plist"
					"*.tex diff=tex"
					"*.yaml diff=yaml"
					"*.yml diff=yaml"
				];

				delta = {
					enable = true;
					options = {
						dark = true;
						light = false;
						line-numbers = true;
						navigate = true;
						syntax-theme = "Visual Studio Dark+";
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
						hooksPath = "${config.xdg.configHome}/git/hooks";
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
						guitool = "opendiff";
						mnemonicPrefix = true;
						renames = true;
						json = {
							textConv = "jq --sort-keys '.'";
							cachetextconv = true;
						};
						plist = {
							textConv = "plist2xml";
							cachetextconv = true;
							binary = true;
						};
						tex = {
							xfuncname = ''^(\\\\(sub)*section\\{.*)$'';
						};
						yaml = {
							textConv = "yq 'sort_keys(..)'";
							cachetextconv = true;
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
						file = "${darwinConfig.sops.templates."git/mailmap".path}";
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
						sign = {
							cmd = "git author";
							ifExists = "addIfDifferent";
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
					"*~" ## backup files
					".DS_Store" ## MacOS folder view settings
					".Spotlight-V100" ## MacOS search index
					".Trashes" ## MacOS trash bin
					"._*" ## MacOS thumbnail cache
					".direnv"
					".tmp"
					"Desktop.ini" ## Windows folder view settings
					"Thumbs.db" ## Windows thumbnail cache
					"tmp"
				];

				lfs = {
					enable = true;
				};

				signing = {
					format = "openpgp";
					signByDefault = true;
					signer = lib.getExe pkgs.gnupg;
				};
			};

			xdg.configFile."git/hooks/commit-msg" = {
				enable = config.programs.git.enable;
				executable = true;
				text = pkgs.lib.local.unindent ''
					#!${pkgs.runtimeShell}

					${lib.getExe config.programs.git.package} interpret-trailers --trailer "sign" --trim-empty "$1" | ${lib.getExe' pkgs.moreutils "sponge"} "$1"
				'';
			};

			## TODO create plist2xml executable
			## exec ${lib.getExe pkgs.libplist} --format xml --infile "$1"
		})
	];

	sops = {
		templates = {
			"git/mailmap" = {
				## TODO refactor mailmap
				# {{- range $_, $email := splitList " " .personal.pastEmails }}
				# {{ $.personal.name.preferred }} <{{ $.personal.gitEmail }}> <{{ $email }}>
				# {{- end }}
				content = pkgs.lib.local.unindent ''
					${config.sops.placeholder.preferredName} <${config.sops.placeholder."home/email"}>
					GitHub Actions <actions@github.com>
					GitHub Actions <actions@github.com> <41898282+github-actions[bot]@users.noreply.github.com>
					GitHub Actions <actions@github.com> <49699333+dependabot[bot]@users.noreply.github.com>
					GitHub Actions <actions@github.com> <49736102+kodiakhq[bot]@users.noreply.github.com>
					GitHub Actions <actions@github.com> <66853113+pre-commit-ci[bot]@users.noreply.github.com>
				'';
				owner = config.system.primaryUser;
				group = "staff";
				mode = "0400";
			};
		};
	};
}
