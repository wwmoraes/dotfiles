{ config
, lib
, pkgs
, ...
}: rec {
	environment.infoPath = lib.mkAfter [
		"/usr/local/MacGPG2/share/info"
	];

	# environment.manPath = lib.mkAfter [
	# 	"/usr/local/MacGPG2/share/man"
	# ];

	environment.systemPackages = [
		pkgs.gnupg
		pkgs.pinentry-tty
	];

	environment.systemPath = lib.mkOrder 1100 [
		(toString (/. + "${config.homebrew.brewPrefix}/../opt/coreutils/libexec/gnubin"))
	];

	environment.variables = {
		SSH_AUTH_SOCK = "$HOME/.gnupg/S.gpg-agent.ssh";
		XDG_DATA_DIRS = lib.mkAfter [
			"/usr/local/MacGPG2/share"
		];
	};

	homebrew.casks = [
		"gpg-suite-no-mail" ## TODO globalCask
	];

	launchd.user.agents = {
		# pkill "gpg-agent|ssh-agent|pinentry"
		# gpg-agent --csh --daemon --enable-ssh-support
		# gpg-connect-agent updatestartuptty /bye
		"dev.artero.gnupg.gpg-agent" = {
			serviceConfig = {
				Label = "dev.artero.gnupg.gpg-agent";
				RunAtLoad = true;
				KeepAlive = false;
				ProgramArguments = [
					# "/usr/local/MacGPG2/bin/gpg-connect-agent"
					"${lib.getExe' pkgs.gnupg "gpg-connect-agent"}"
					"/bye"
				];
			};
		};

		# "dev.artero.hidutil.YubiKey" = {
		# 	serviceConfig = {
		# 		Label = "dev.artero.hidutil.YubiKey";
		# 		LaunchEvents = {
		# 			"com.apple.iokit.matching" = {
		# 				"com.apple.device-attach" = {
		# 					IOMatchStream = true;
		# 					IOMatchLaunchStream = true;
		# 					IOProviderClass = "IOUSBDevice";
		# 					## echo "ibase=16; 1050" | bc
		# 					# idProduct = 1031; # 0x407
		# 					idProduct = "*"; # 0x407
		# 					idVendor = 4176; # 0x1050
		# 				};
		# 			};
		# 		};
		# 		ProgramArguments = [
		# 			# "/usr/local/bin/xpc_set_event_stream_handler"
		# 			"${lib.getExe pkgs.gnupg}"
		# 			"--card-status"
		# 		];
		# 	};
		# };
	};

	launchd.user.envVariables = environment.variables;
}
