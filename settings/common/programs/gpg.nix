{ config
, lib
, pkgs
, ...
}: {
	home-manager.sharedModules = [
		({ config, ...}: {
			home.file = {
				"${config.programs.gpg.homedir}/dirmngr.conf" = {
					enable = true;
					text = pkgs.lib.local.unindent ''
						allow-version-check

						keyserver hkps://keys.openpgp.org
						keyserver hkp://zkaan2xfbuxia2wpf7ofnkbz6r5zdbbvxbunvp5g2iebopbfc4iqmbad.onion
						keyserver hkps://keyserver.pgp.com
						keyserver hkps://keyserver.ubuntu.com
						keyserver hkps://pgp-servers.net
						keyserver hkps://pgp.circl.lu
						keyserver hkps://pgp.id
						keyserver hkps://pgp.mit.edu
						keyserver hkps://pgp.surf.nl
						keyserver hkps://pgpkeys.eu
					'';
				};
			};

			programs.gpg = {
				enable = true;

				publicKeys = [
					{
						## TODO move to a better setting
						source = ../../../pgp/wwmoraes.asc;
						trust = "ultimate";
					}
				];

				scdaemonSettings = {
					## avoids a problem where GnuPG repeatedly prompts to insert an already-inserted YubiKey
					disable-ccid = true;
				};

				## TODO get key ID from a variable
				settings = {
					armor = true;
					auto-key-locate = builtins.concatStringsSep " " [
						"clear"
						"wkd"
						"dane"
						"pka"
						"cert"
						"local"
						"nodefault"
					];
					auto-key-retrieve = true;
					cert-digest-algo = "SHA512";
					default-key = "32B4330B1B66828E4A969EEBEED994645D7C9BDE";
					default-keyserver-url = "https://artero.dev/pgp.asc";
					default-new-key-algo = "ed25519/cert";
					default-preference-list = builtins.concatStringsSep " " [
						"SHA512"
						"SHA384"
						"SHA256"
						"AES256"
						"AES192"
						"AES"
						"ZLIB"
						"BZIP2"
						"ZIP"
						"Uncompressed"
					];
					display-charset = "utf-8";
					keyid-format = "long";
					keyserver-options = builtins.concatStringsSep " " [
						"honor-keyserver-url"
						"include-revoked"
					];
					list-options = builtins.concatStringsSep " " [
						"show-uid-validity"
						# "show-unusable-subkeys"
					];
					no-comments = true;
					no-emit-version = true;
					no-greeting = true;
					no-symkey-cache = true;
					personal-cipher-preferences = builtins.concatStringsSep " " [
						"AES256"
						"AES192"
						"AES"
					];
					personal-compress-preferences = builtins.concatStringsSep " " [
						"ZLIB"
						"BZIP2"
						"ZIP"
						"Uncompressed"
					];
					personal-digest-preferences = builtins.concatStringsSep " " [
						"SHA512"
						"SHA384"
						"SHA256"
					];
					pinentry-mode = "ask";
					require-cross-certification = true;
					require-secmem = true;
					s2k-cipher-algo = "AES256";
					s2k-digest-algo = "SHA512";
					sig-keyserver-url = "https://artero.dev/pgp.asc";
					throw-keyids = true;
					tofu-default-policy = "unknown";
					trust-model = "tofu+pgp";
					trusted-key = "32B4330B1B66828E4A969EEBEED994645D7C9BDE";
					verbose = false;
					verify-options = "show-uid-validity";
					with-fingerprint = true;
					with-key-origin = true;
					with-keygrip = true;
					with-secret = false;
					with-sig-check = false;
					with-subkey-fingerprint = true;
					with-wkd-hash = true;
				};
			};

			services.gpg-agent = {
				enable = true;

				defaultCacheTtl = 60;
				defaultCacheTtlSsh = 60;
				enableSshSupport = true;
				grabKeyboardAndMouse = true;
				maxCacheTtl = 120;
				maxCacheTtlSsh = 120;
				noAllowExternalCache = true;

				pinentry = {
					package = pkgs.pinentry_mac;
					program = "pinentry-mac";
				};
			};
		})
	];

	# homebrew.casks = [
	# 	(pkgs.lib.local.globalCask "gpg-suite-no-mail")
	# ];

	## TODO remove?
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
}
