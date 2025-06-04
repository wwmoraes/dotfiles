{ config
, ...
}: {
	sops = {
		age = {
			sshKeyPaths = [];
			generateKey = false;
		};
		defaultSopsFile = ../../external/secrets.yaml;
		gnupg = {
			home = config.home-manager.users.william.programs.gpg.homedir;
			sshKeyPaths = [];
		};
		secrets = {
			"personal/me/contact/emailAddress" = {};
			"personal/me/firstName" = {};
		};
	};
}
