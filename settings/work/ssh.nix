{ config
, pkgs
, ...
}: {
	home-manager.sharedModules = [
		({
			programs.ssh = {
				includes = [
					"${config.sops.templates."ssh/work".path}"
				];
			};
		})
	];

	sops = {
		secrets = {
			"work/email" = {};
			"work/launcher/username" = {};
			"work/pcs/domain" = {};
		};

		templates = {
			"ssh/work" = {
				content = pkgs.lib.local.unindent ''
					Host cocodev cocodev.${config.sops.placeholder."work/pcs/domain"}
					HostName cocodev.${config.sops.placeholder."work/pcs/domain"}
					User ${config.sops.placeholder."work/launcher/username"}
				'';
				owner = config.system.primaryUser;
				group = "staff";
				mode = "0400";
			};
		};
	};
}
