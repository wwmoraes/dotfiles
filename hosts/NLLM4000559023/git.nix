{ pkgs
, config
, lib
, ...
}: {
	home-manager.users.${config.system.primaryUser} = {
		programs.git = {
			extraConfig = {
				core = {
					commentChar = "|";
				};
				# diff = {
				# 	## SSNS is so bloated that even the sane defaults aren't enough
				# 	renameLimit = 16384;
				# };
				credential = {
					helper = "manager";
					useHttpPath = true;
				};
			};

			includes = [
				{ path = "${config.sops.templates."git/work".path}"; }
				{
					path = "${config.sops.templates."git/home".path}";
					condition = "hasconfig:remote.*.url:https://github.com/**";
				}
			];
		};
	};

	homebrew.casks = [
		"git-credential-manager"
	];

	sops = {
		secrets = {
			"work/email" = {};
			preferredName = { key = "personal/me/preferredName"; };
			"home/email" = { key = "personal/me/contact/emailAddress"; };
		};

		templates = {
			"git/home" = {
				content = lib.generators.toGitINI {
					user = {
						email = "${config.sops.placeholder."home/email"}";
						name = "${config.sops.placeholder.preferredName}";
					};
				};
				owner = config.system.primaryUser;
				group = "staff";
				mode = "0400";
			};
			"git/work" = {
				content = lib.generators.toGitINI {
					user = {
						email = "${config.sops.placeholder."work/email"}";
						name = "${config.sops.placeholder.preferredName}";
					};
				};
				owner = config.system.primaryUser;
				group = "staff";
				mode = "0400";
			};
		};
	};
}
