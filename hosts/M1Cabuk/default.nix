{ pkgs
, config
, lib
, ...
}: rec {
	imports = [
		./1password.nix
	];

	environment.systemPackages = [
		# pkgs.cilium-cli
		pkgs.cachix
		pkgs.talosctl
	];

	environment.variables = launchd.user.envVariables // {
		PROJECTS_DIR = "$HOME/dev";
	};

	home-manager.users.${config.system.primaryUser} = {
		programs.git = {
			extraConfig = {
				push = {
					negotiate = true;
				};
			};
			includes = [
				{ path = "${config.sops.templates."git/home".path}"; }
			];
		};
	};

	homebrew.brews = [
		# "cfengine"
		# "qcachegrind"
		"snipkit"
	];

	homebrew.casks = [
		"airbuddy"
		"airtable"
		"android-file-transfer"
		"android-platform-tools"
		"app-cleaner" # Nektony App Cleaner & Uninstaller
		"appcleaner"
		"balenaetcher"
		"calibre"
		"chromium"
		"cyberduck"
		"discord"
		"dropbox"
		"duckduckgo"
		"fluor"
		"hakuneko"
		"image2icon"
		"inkscape"
		"keybase"
		"knockknock"
		"launchcontrol"
		(pkgs.lib.local.globalCask "little-snitch")
		"logseq"
		"macpass"
		"mate-translate"
		"messenger"
		"netnewswire"
		"onyx"
		"plex"
		"plex-htpc"
		"raspberry-pi-imager"
		"resilio-sync"
		"signal"
		"soulver"
		"soundsource"
		"sqlitestudio"
		"steam"
		"telegram"
		"thingsmacsandboxhelper"
		"tiddly"
		"yattee"
		(pkgs.lib.local.globalCask "yubico-yubikey-manager")
		"zotero@beta"
	];

	homebrew.masApps = {
		"Apple Configurator" = 1037126344;
		"Be Focused Pro" = 961632517;
		"CCMenu" = 603117688;
		"DoMarks" = 1518886084;
		"GarageBand" = 682658836;
		"Just Press Record" = 1033342465;
		"Keynote" = 409183694;
		"Numbers" = 409203825;
		"OX Drive" = 818195014;
		"Parcel" = 639968404;
		"Privacy Redirect" = 1578144015;
		"StopTheMadness" = 1376402589;
		"Supernote Partner" = 1494992020;
		# "SwiftoDo Desktop" = 1143641091;
		"Tampermonkey Classic" = 1482490089;
		"TestFlight" = 899247664;
		"Things" = 904280696;
		"Userscripts-Mac-App" = 1463298887;
		"WireGuard" = 1451685025;
		"Xcode" = 497799835;
		# "Yubico Authenticator" = 1497506650;
		"iMovie" = 408981434;
		"uBlacklist for Safari" = 1547912640;
	};

	homebrew.taps = [
		"lemoony/tap" # snipkit
	];

	launchd.user.envVariables = {
		DOT_ENVIRONMENT = "home";
	};

	nixpkgs.hostPlatform = "aarch64-darwin";

	sops = {
		secrets = {
			"home/email" = { key = "personal/me/contact/emailAddress"; };
			preferredName = { key = "personal/me/preferredName"; };
			smtpPort = { key = "personal/me/email/smtp/port"; };
			smtpServer = { key = "personal/me/email/smtp/server"; };
			smtpUser = { key = "personal/me/email/smtp/user"; };
		};

		templates = {
			".secrets.env" = {
				content = lib.generators.toKeyValue {} {
					EMAIL = "${config.sops.placeholder."home/email"}";
				};
				path = "${config.system.primaryUserHome}/.secrets.env";
				owner = config.system.primaryUser;
				group = "staff";
				mode = "0400";
			};

			"git/home" = {
				content = lib.generators.toGitINI {
					user = {
						email = "${config.sops.placeholder."home/email"}";
						name = "${config.sops.placeholder.preferredName}";
					};
					sendEmail = {
						smtpEncryption = "tls";
						smtpServer = "${config.sops.placeholder.smtpServer}";
						smtpServerPort = "${config.sops.placeholder.smtpPort}";
						smtpUser = "${config.sops.placeholder.smtpUser}";
					};
				};
				owner = config.system.primaryUser;
				group = "staff";
				mode = "0400";
			};
		};
	};
}
