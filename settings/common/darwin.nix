{ config
, lib
, pkgs
, ...
}:
with builtins;
let
	mkSystem = lib.mkOrder 2000;
	home = getEnv "HOME";
	listDirRegularPaths = root: map (lib.path.append root) (attrNames (lib.filterAttrs (_: v: v == "regular") (readDir root)));
	readPathsFromFiles = files: lib.flatten (map readPathsFromFile files);
	readPathsFromFile = f: filter pathExists (map (p: /. + p) (filter (v: v != "") (lib.splitString "\n" (readFile f))));
in rec {
	environment.extraOutputsToInstall = [
		"info"
	];

	environment.systemPackages = [
		pkgs.bat
		pkgs.coreutils
		pkgs.envsubst
		pkgs.expect
		pkgs.fd
		pkgs.fswatch
		pkgs.gawk
		pkgs.graphviz
		pkgs.grc
		pkgs.jq
		pkgs.moreutils
		pkgs.ripgrep
		pkgs.tlrc
		pkgs.yazi
		pkgs.zellij
		pkgs.unstable.pet
	];

	environment.systemPath = lib.mkMerge [
		(lib.mkBefore [
			"$HOME/.local/bin"
			"$HOME/.cargo/bin"
			"$HOME/.cabal/bin"
		])
		# (lib.mkOrder 1100 (readPathsFromFiles (listDirRegularPaths /etc/paths.d)))
		(lib.mkOrder 1100 [
			"/Library/Apple/usr/bin" ## rvictl
			# "/Applications/Little Snitch.app/Contents/Components"	## TODO little snitch
			"/Applications/Keybase.app/Contents/SharedSupport/bin" ## TODO Keybase
			"/Library/TeX/texbin" ## TODO tex path
		])
		(lib.mkOrder 1200 ["/usr/local/sbin"])
	];

	environment.variables = {
		## https://geoff.greer.fm/lscolors/
		## BSD: LSCOLORS; Linux: LS_COLORS
		LSCOLORS = "exfxcxdxbxeghdabagacad";
		MANPAGER = "less";
		# NIX_PATH = config.nix.nixPath;
		# NIX_PROFILES = (lib.concatStringsSep " " (lib.reverseList config.environment.profiles));
		# NIX_USER_PROFILE_DIR = "/nix/var/nix/profiles/per-user/$USER";
		PAGER = "less";
		XDG_DATA_DIRS = lib.mkMerge [
			(mkSystem [
				"/usr/local/share"
				"/usr/share"
			])
		];
	};
	home-manager.sharedModules = [({ config, lib, ... }: {
		home.activation.gpgCardSwitch = lib.hm.dag.entryAfter ["importGpgKeys" "createGpgHomedir"] (let
			gpgBin = lib.getExe config.programs.gpg.package;
			gpgconfBin = lib.getExe' config.programs.gpg.package "gpgconf";
		in pkgs.lib.local.unindent ''
			export GNUPGHOME=${lib.escapeShellArg config.programs.gpg.homedir}

			for fingerprint in $(${gpgBin} --options /dev/null --card-status 2> /dev/null | grep -B1 "card-no:" | grep "ssb>" | cut -d"/" -f2 | cut -d" " -f1); do
				KEYGRIP=$(${gpgBin} --list-keys --with-keygrip --with-colons $fingerprint! | grep -A1 $fingerprint | grep '^grp:' | cut -d: -f10)
				rm "$GNUPGHOME/private-keys-v1.d/$KEYGRIP.key" 2>/dev/null || true
			done

			${gpgconfBin} --kill gpg-agent
			${gpgBin} --card-status > /dev/null
		'');
		home.activation.developerGroupMembership = lib.hm.dag.entryAfter ["writeBoundary"] ''
			if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _developer > /dev/null); then
				echo >&2 "adding user ${config.home.username} to group _developer"
				sudo dscl . append /Groups/_developer GroupMembership "${config.home.username}"
			fi
		'';
		home.activation.webdeveloperGroupMembership = lib.hm.dag.entryAfter ["writeBoundary"] ''
			if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _webdeveloper > /dev/null); then
				echo >&2 "adding user ${config.home.username} to group _webdeveloper"
				sudo dscl . append /Groups/_webdeveloper GroupMembership "${config.home.username}"
			fi
		'';
		## skipping this for now as the write replaces the group in the policy instead of adding
		# echo "allowing _developer members to change system preferences"
		# # shellcheck disable=SC2024
		# sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
		# sudo defaults write /tmp/system.preferences.plist group _developer
		# # shellcheck disable=SC2024
		# sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
	})];

	homebrew.brews = [
		"gh" ## used internally by brew taps
		"mas" ## used internally by brew masApps
	];

	homebrew.casks = [
		"anytype"
		"automatic-mouse-mover"
		"bartender"
		"betterzip"
		"bruno"
		"das-keyboard-q"
		"displaylink-login-screen-ext"
		(pkgs.lib.local.globalCask "displaylink-manager")
		"elgato-stream-deck"
		"finicky"
		"firefox"
		"flux"
		"gas-mask"
		"gimp"
		"hammerspoon"
		(pkgs.lib.local.globalCask "jabra-direct")
		"jtool2"
		"kitty"
		"launchpad-manager"
		"macfuse"
		"provisionql"
		"qlcolorcode"
		"qlmarkdown"
		"qlvideo"
		"spotify"
		"suspicious-package"
		"swiftbar"
		"the-unarchiver"
		"uninstallpkg"
		"zap"
	];

	homebrew.taps = [
		"homebrew/bundle"
		"homebrew/services"
		"wwmoraes/tap"
	];

	# launchd.daemons = {
	#   "dev.artero.limit.maxfiles" = {
	#     serviceConfig = {
	#       Label = "dev.artero.limit.maxfiles";
	#       ProgramArguments = [
	#         "launchctl"
	#         "limit"
	#         "maxfiles"
	#         "1048576"
	#         "1048576"
	#       ];
	#       RunAtLoad = true;
	#     };
	#   };
	#   "dev.artero.limit.maxproc" = {
	#     serviceConfig = {
	#       Label = "dev.artero.limit.maxproc";
	#       ProgramArguments = [
	#         "launchctl"
	#         "limit"
	#         "maxproc"
	#         "65536"
	#         "65536"
	#       ];
	#       RunAtLoad = true;
	#     };
	#   };
	#   "dev.artero.sysctl" = {
	#     serviceConfig = {
	#       Label = "dev.artero.sysctl";
	#       ProgramArguments = [
	#         "/usr/sbin/sysctl"
	#         "kern.maxfiles=1048576"
	#         "kern.maxfilesperproc=65536"
	#       ];
	#       RunAtLoad = true;
	#     };
	#   };
	# };

	launchd.user.agents = {
		"dev.artero.environment" = {
			script = let
				home = builtins.getEnv "HOME";
				launchctlEnv = key: value:
					if value != null
					then "launchctl setenv ${key} ${lib.escapeShellArg (builtins.replaceStrings ["$HOME" "\${HOME}"] [home home] value)}"
					else "launchctl unsetenv ${key}";
			in lib.concatStringsSep "\n" [
				(lib.concatStringsSep "\n" (lib.mapAttrsToList launchctlEnv config.launchd.user.envVariables))
				## purges 'Open With' duplicates + reloads environment variables
				# "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user"
			];
			serviceConfig = {
				Label = "dev.artero.environment";
				LimitLoadToSessionType = [
					"Aqua"
					"StandardIO"
					"Background"
				];
				RunAtLoad = true;
				# StandardErrorPath = (/. + (builtins.getEnv "HOME") + /Library/Logs/dev.artero.environment.err.log);
				# StandardOutPath = (/. + (builtins.getEnv "HOME") + /Library/Logs/dev.artero.environment.out.log);
			};
		};
		# https://gist.github.com/paultheman/808be117d447c490a29d6405975d41bd
		# https://hidutil-generator.netlify.app/
		"dev.artero.hidutil.BTRemoteShutter" = {
			serviceConfig = {
				Label = "dev.artero.hidutil.BTRemoteShutter";
				LaunchEvents = {
					"com.apple.iokit.matching" = {
						"com.apple.bluetooth.hostController" = {
							IOMatchLaunchStream = true;
							IOProviderClass = "IOBluetoothHCIController";
							idProduct = 12850; # 0x3232
							idVendor = 1452; # 0x5ac
						};
					};
				};
				# hidutil property --matching '{"VendorID":1452,"ProductID":12850}' --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingDst":30064771152,"HIDKeyboardModifierMappingSrc":30064771112},{"HIDKeyboardModifierMappingDst":30064771151,"HIDKeyboardModifierMappingSrc":51539607785}]}''
				# hidutil property --matching '{"ProductID":12850,"VendorID":1452}' --get "UserKeyMapping"
				ProgramArguments = [
					# "/usr/local/bin/xpc_set_event_stream_handler"
					"/usr/bin/hidutil"
					"property"
					"--matching"
					(builtins.toJSON {
						VendorID = 1452; # 0x5ac
						ProductID = 12850; # 0x3232
					})
					"--set"
					(builtins.toJSON {
						UserKeyMapping = [
							{
								HIDKeyboardModifierMappingSrc = 30064771112; # 0x700000028 return_or_enter
								HIDKeyboardModifierMappingDst = 30064771152; # 0x700000050 left_arrow
							}
							{
								HIDKeyboardModifierMappingSrc = 51539607785; # 0xC000000E9 volume_increment
								HIDKeyboardModifierMappingDst = 30064771151; # 0x70000004F right_arrow
							}
						];
					})
				];
				RunAtLoad = true;
			};
		};
	};

	system.activationScripts.postActivation.text = pkgs.lib.local.unindent ''
		if ! _=$(/usr/sbin/DevToolsSecurity -status | grep -Fx "Developer mode is currently enabled." > /dev/null); then
			printf >&2 "enabling developer mode...\n"
			/usr/sbin/DevToolsSecurity -enable
		fi

		printf >&2 "allowing any app source...\n"
		spctl --master-enable

		printf >&2 "cleaning up root mail...\n"
		echo 'd *' | mailx > /dev/null 2>&1 || true

		printf >&2 "reloading quicklook plugins...\n"
		qlmanage -r

		printf >&2 "reloading system settings...\n"
		/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

		printf >&2 "reloading preferences...\n"
		killall cfprefsd
	'';

	system.authorizationDB = {
		## Used by task_for_pid(...). Task_for_pid is called by programs requesting full
		## control over another program for things like debugging or performance
		## analysis. This authorization only applies if the requesting and target
		## programs are run by the same user; it will never authorize access to the
		## program of another user.
		# "system.privilege.taskport" = "authenticate-developer";
	};

	system.defaults = {
		ActivityMonitor = {
			IconType = 5;
			OpenMainWindow = true;
			ShowCategory = 100;
			SortColumn = "CPUUsage";
			SortDirection = 0;
		};
		CustomUserPreferences = {
			"com.ameba.SwiftBar" = let
				rootFolder = (toString (/. + home + "/Library/Application Support/SwiftBar"));
			in {
				DisableBashWrapper = true;
				MakePluginExecutable = false;
				NSNavLastRootDirectory = rootFolder;
				PluginDebugMode = true;
				PluginDeveloperMode = true;
				PluginDirectory = rootFolder + "/plugins";
				StealthMode = true;
				StreamablePluginDebugOutput = false;
			};
			"com.apple.Accessibility" = {
				EnhancedBackgroundContrastEnabled = 1;
			};
			# "com.apple.AddressBook" = {
			#   ABNameSortingFormat = "sortingFirstName sortingLastName";
			#   ABShowDebugMenu = true;
			#   ABDefaultAddressCountryCode = "nl";
			# };
			"com.apple.AppleMultitouchTrackpad" = {
				TrackpadFiveFingerPinchGesture = 2;
				TrackpadFourFingerHorizSwipeGesture = 2;
				TrackpadFourFingerPinchGesture = 2;
				TrackpadFourFingerVertSwipeGesture = 2;
				TrackpadHandResting = true;
				TrackpadHorizScroll = 1;
				TrackpadMomentumScroll = true;
				TrackpadPinch = 1;
				TrackpadRotate = 1;
				TrackpadScroll = true;
				TrackpadThreeFingerVertSwipeGesture = 2;
				TrackpadTwoFingerDoubleTapGesture = 1;
				TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
			};
			"com.apple.assistant.support" = {
				"Assistant Enabled" = false;
			};
			"com.apple.CrashReporter" = {
				DialogType = "none";
			};
			"com.apple.desktopservices" = {
				DSDontWriteNetworkStores = true;
				DSDontWriteUSBStores = true;
				UseBareEnumeration = true;
			};
			"com.apple.DiskUtility" = {
				advanced-image-options = true;
				DUDebugMenuEnabled = true;
			};
			"com.apple.dock" = {
				# TODO contribute to system.defaults.dock
				showAppExposeGestureEnabled = true;
				workspaces-auto-swoosh = true;
				wvous-bl-modifier = 0;
				wvous-br-modifier = 0;
				wvous-tl-modifier = 0;
				wvous-tr-modifier = 0;
			};
			"com.apple.driver.AppleBluetoothMultitouch.trackpad" = system.defaults.trackpad // system.defaults.CustomUserPreferences."com.apple.AppleMultitouchTrackpad";
			"com.apple.dt.Xcode" = {
				XcodeCloudUpsellPromptEnabled = false;
			};
			"com.apple.finder" = rec {
				_FXSortFoldersFirst = true;
				DesktopViewSettings = FK_StandardViewSettings;
				DisableAllAnimations = true;
				FinderSpawnTab = false;
				FK_StandardViewSettings = {
					IconViewSettings = {
						arrangeBy = "grid";
						gridSpacing = 1.0;
						iconSize = 64.0;
						showItemInfo = true;
						# labelOnBottom = false;
					};
				};
				FXEnableRemoveFromICloudDriveWarning = false;
				FXInfoPanesExpanded = {
					General = true;
					MetaData = false;
					Name = true;
					OpenWith = true;
					Preview = false;
					Privileges = false;
				};
				NewWindowTarget = "PfHm";
				NewWindowTargetIsHome = true;
				NewWindowTargetPath = ""; # NewWindowTargetPath: "file://${HOME}/"
				OpenWindowForNewRemovableDisk = true;
				QLEnableTextSelection = true;
				ShowExternalHardDrivesOnDesktop = true;
				ShowHardDrivesOnDesktop = false;
				ShowMountedServersOnDesktop = false;
				ShowRecentTags = false;
				ShowRemovableMediaOnDesktop = true;
				StandardViewSettings = FK_StandardViewSettings;
				WarnOnEmptyTrash = false;
			};
			"com.apple.frameworks.diskimages" = {
				auto-open-ro-root = true;
				auto-open-rw-root = true;
				skip-verify = true;
				skip-verify-locked = true;
				skip-verify-remote = true;
			};
			"com.apple.GameController" = {
				bluetoothPrefsMenuLongPressAction = 0;
				bluetoothPrefsShareLongPressSystemGestureMode = 1;
			};
			# "com.apple.helpviewer" = {
			# 	DevMode = true;
			# };
			"com.apple.iCal" = {
				privacyPaneHasBeenAcknowledgedVersion = 4;
				IncludeDebugMenu = true;
				"n days of week" = 7;
				"first day of week" = 0;
				"scroll by weeks in week view" = 1;
				"first minute of work hours" = 540;
				"last minute of work hours" = 1020;
				"number of hours displayed" = 10;
				SharedCalendarNotificationsDisabled = true;
				InvitationNotificationsDisabled = false;
				"Show heat map in Year View" = false;
				OpenEventsInWindowType = false;
				WarnBeforeSendingInvitations = false;
				CalendarSidebarShown = true;
				"add holiday calendar" = true;
				"Default duration in minutes for new event" = 30.0;
				"display birthdays calendar" = true;
				"Show time in Month View" = true;
				"Show Week Numbers" = false;
				"TimeZone support enabled" = true;
				ShowDeclinedEvents = false;
				TimeToLeaveEnabled = true;
			};
			"com.apple.ImageCapture" = {
				disableHotPlug = true;
			};
			"com.apple.messageshelper.MessageController" = {
				SOInputLineSettings = {
					automaticEmojiSubstitutionEnablediMessage = false;
					automaticQuoteSubstitutionEnabled = false;
					continuousSpellCheckingEnabled = false;
				};
			};
			"com.apple.NetworkBrowser" = {
				BrowseAllInterfaces = true;
			};
			"com.apple.PowerChime" = {
				ChimeOnAllHardware = false;
			};
			"com.apple.print.PrintingPrefs" = {
				"Quit When Finished" = true;
			};
			# "com.apple.QuickTimePlayerX" = {
			# 	MGPlayMovieOnOpen = true;
			# };
			"com.apple.SafariTechnologyPreview" = {
				"com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback" = false;
				WebKitMediaPlaybackAllowsInline = false;
			};
			"com.apple.ScriptEditor2" = {
				ApplePersistence = false;
			};
			"com.apple.security.authorization" = {
				ignoreArd = true;
			};
			"com.apple.Siri" = {
				StatusMenuVisible = false;
				VoiceTriggerUserEnabled = false;
			};
			"com.apple.SoftwareUpdate" = {
				## Enable the automatic update check
				AutomaticCheckEnabled = true;
				## Download newly available updates in background
				AutomaticDownload = 1;
				## Don't download apps purchased on other Macs
				ConfigDataInstall = 0;
				## Install System data files & security updates
				CriticalUpdateInstall = 1;
				## Check for software updates daily, not just once per week
				ScheduleFrequency = 1;
			};
			"com.apple.spotlight" = {
				orderedItems = [
					{ enabled = 1; name = "APPLICATIONS"; }
					{ enabled = 1; name = "MENU_EXPRESSION"; }
					{ enabled = 1; name = "MENU_CONVERSION"; }
					{ enabled = 1; name = "MENU_DEFINITION"; }
					{ enabled = 1; name = "SYSTEM_PREFS"; }
					{ enabled = 1; name = "BOOKMARKS"; }
					{ enabled = 1; name = "DIRECTORIES"; }
					{ enabled = 0; name = "PDF"; }
					{ enabled = 0; name = "FONTS"; }
					{ enabled = 0; name = "DOCUMENTS"; }
					{ enabled = 0; name = "MESSAGES"; }
					{ enabled = 0; name = "CONTACT"; }
					{ enabled = 0; name = "EVENT_TODO"; }
					{ enabled = 0; name = "IMAGES"; }
					{ enabled = 0; name = "MUSIC"; }
					{ enabled = 0; name = "MOVIES"; }
					{ enabled = 0; name = "PRESENTATIONS"; }
					{ enabled = 0; name = "SPREADSHEETS"; }
					{ enabled = 0; name = "SOURCE"; }
					{ enabled = 0; name = "MENU_OTHER"; }
					{ enabled = 0; name = "MENU_WEBSEARCH"; }
					{ enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
				];
				showedFTE = 1;
				showedLearnMore = 1;
			};
			"com.apple.systemuiserver" = {
				"NSStatusItem Visible com.apple.menuextra.appleuser" = false;
				"NSStatusItem Visible com.apple.menuextra.bluetooth" = false;
				"NSStatusItem Visible com.apple.menuextra.clock" = false;
				"NSStatusItem Visible com.apple.menuextra.volume" = false;
				dontAutoLoad = [
					"/System/Library/CoreServices/Menu Extras/AirPort.menu"
					"/System/Library/CoreServices/Menu Extras/VPN.menu"
					"/System/Library/CoreServices/Menu Extras/WWAN.menu"
					# "/System/Library/CoreServices/Menu Extras/Clock.menu"
					# "/System/Library/CoreServices/Menu Extras/Displays.menu"
					# "/System/Library/CoreServices/Menu Extras/DwellControl.menu"
					# "/System/Library/CoreServices/Menu Extras/Eject.menu"
					# "/System/Library/CoreServices/Menu Extras/ExpressCard.menu"
					# "/System/Library/CoreServices/Menu Extras/GamePolicyExtra.menu"
					# "/System/Library/CoreServices/Menu Extras/PPP.menu"
					# "/System/Library/CoreServices/Menu Extras/PPPoE.menu"
					# "/System/Library/CoreServices/Menu Extras/SafeEjectGPUExtra.menu"
					# "/System/Library/CoreServices/Menu Extras/User.menu"
					# "/System/Library/CoreServices/Menu Extras/Volume.menu"
				];
			};
			"com.apple.Terminal" = {
				SecureKeyboardEntry = true;
				Shell = "${pkgs.fish}/bin/fish";
				ShowLineMarks = 0;
				StringEncodings = ["4"];
			};
			# "com.apple.TextEdit" = {
			# 	PlainTextEncoding = 4;
			# 	PlainTextEncodingForWrite = 4;
			# 	RichText = 0;
			# };
			"com.apple.TextInputMenu" = {
				visible = false;
			};
			# "com.apple.TimeMachine" = {
			# 	DoNotOfferNewDisksForBackup = true;
			# };
			# "com.apple.universalaccess" = {
			# 	"com.apple.custommenu.apps" = [
			# 		# "net.kovidgoyal.kitty"
			# 		"NSGlobalDomain"
			# 	];
			# 	# reduceTransparency = 1;
			# };
			NSGlobalDomain = {
				## TODO com.apple.finder.SyncExtensions
				AppleEnableMenuBarTransparency = false;
				AppleLanguages = ["en-NL" "en-GB" "pt-BR"];
				AppleLocale = "en_GB@currency=EUR";
				CGFontRenderingFontSmoothingDisabled = false;
				NSAllowContinuousSpellChecking = false;
				NSPersonNameDefaultDisplayNameOrder = 1;
				## To find apps with custom hotkeys set:
				##   defaults find NSUserKeyEquivalents
				##   defaults read com.apple.universalaccess com.apple.custommenu.apps
				## Syntax:
				##   command = @
				##   control = ^
				##   option = ~
				##   shift = $
				NSUserKeyEquivalents = {
					"Enter Full Screen" = "@^f";
					"Return to Previous Size" = "";
					Bottom = "^$\\U2193";
					"Bottom &amp; Quarters" = "";
					"Bottom &amp; Top" = "~^$\\U2193";
					"Left &amp; Quarters" = "";
					"Left &amp; Right" = "~^$\\U2190";
					"Right &amp; Left" = "~^$\\U2192";
					"Right &amp; Quarters" = "";
					"Top &amp; Bottom" = "~^$\\U2191";
					"Top &amp; Quarters" = "";
					Centre = "^$c";
					Fill = "^$f";
					Left = "^$\\U2190";
					Right = "^$\\U2192";
					Top = "^$\\U2191";
				};
				QLPanelAnimationDuration = 0;
				WebKitDeveloperExtras = true;
			};
			"com.google.Chrome.canary" = system.defaults.CustomUserPreferences."org.chromium.Chromium";
			"com.google.Chrome" = system.defaults.CustomUserPreferences."org.chromium.Chromium";
			"org.chromium.Chromium" = {
				AppleEnableMouseSwipeNavigateWithScrolls = false;
				AppleEnableSwipeNavigateWithScrolls = false;
				DisablePrintPreview = true;
				PMPrintingExpandedStateForPrint2 = true;
			};
		};
		CustomSystemPreferences = {};
		dock = {
			autohide = true;
			autohide-delay = 0.0;
			autohide-time-modifier = 0.0;
			dashboard-in-overlay = true;
			enable-spring-load-actions-on-all-items = true;
			expose-animation-duration = 0.1;
			magnification = true;
			mineffect = "genie";
			minimize-to-application = true;
			mouse-over-hilite-stack = true;
			mru-spaces = false;
			show-process-indicators = true;
			show-recents = false;
			showhidden = true;
			tilesize = 72;
			wvous-bl-corner = null;
			wvous-br-corner = null;
			wvous-tl-corner = null;
			wvous-tr-corner = null;
		};
		finder = {
			_FXShowPosixPathInTitle = false;
			AppleShowAllFiles = false;
			FXDefaultSearchScope = "SCcf";
			FXEnableExtensionChangeWarning = false;
			FXPreferredViewStyle = "Nlsv";
			ShowPathbar = true;
			ShowStatusBar = true;
		};
		LaunchServices = {
			LSQuarantine = false;
		};
		NSGlobalDomain = {
			"com.apple.mouse.tapBehavior" = 1;
			"com.apple.sound.beep.feedback" = 0;
			"com.apple.springing.delay" = 0.0;
			"com.apple.springing.enabled" = true;
			# NSTextInsertionPointBlinkPeriod = 9999999999999999;
			AppleFontSmoothing = 1;
			AppleInterfaceStyle = "Dark";
			AppleInterfaceStyleSwitchesAutomatically = false;
			AppleKeyboardUIMode = 3;
			AppleMeasurementUnits = "Centimeters";
			AppleMetricUnits = 1;
			ApplePressAndHoldEnabled = false;
			AppleShowAllExtensions = false;
			AppleShowScrollBars = "WhenScrolling";
			AppleWindowTabbingMode = "always";
			InitialKeyRepeat = 15;
			KeyRepeat = 4;
			NSAutomaticCapitalizationEnabled = false;
			NSAutomaticDashSubstitutionEnabled = false;
			NSAutomaticPeriodSubstitutionEnabled = false;
			NSAutomaticQuoteSubstitutionEnabled = false;
			NSAutomaticSpellingCorrectionEnabled = false;
			NSAutomaticWindowAnimationsEnabled = false;
			NSDisableAutomaticTermination = true;
			NSDocumentSaveNewDocumentsToCloud = false;
			NSNavPanelExpandedStateForSaveMode = true;
			NSNavPanelExpandedStateForSaveMode2 = true;
			NSScrollAnimationEnabled = true;
			NSTableViewDefaultSizeMode = 2;
			NSTextShowsControlCharacters = true;
			NSUseAnimatedFocusRing = false;
			NSWindowResizeTime = 0.001;
			PMPrintingExpandedStateForPrint = true;
			PMPrintingExpandedStateForPrint2 = true;
		};
		screencapture = {
			disable-shadow = true;
			location = "~/Library/Mobile Documents/com~apple~CloudDocs/Screenshots";
			type = "png";
		};
		trackpad = {
			Clicking = false;
			TrackpadRightClick = true;
			TrackpadThreeFingerTapGesture = 2;
		};
		WindowManager = {
			AppWindowGroupingBehavior = false; # one at a time
			EnableTiledWindowMargins = false; # removes margin from tiling
			GloballyEnabled = true; # enables stage manager
		};
	};

	system.hotkeys = {hotkey, actions, keys, modifiers}: {
		"${actions.FocusMenuBar}"        = hotkey true keys.F2 (modifiers.Fn + modifiers.Control);
		"${actions.FocusDock}"           = hotkey true keys.F3 (modifiers.Fn + modifiers.Control);
		"${actions.FocusWindow}"         = hotkey true keys.F4 (modifiers.Fn + modifiers.Control);
		"${actions.FocusWindowToolbar}"  = hotkey true keys.F5 (modifiers.Fn + modifiers.Control);
		# "11"  = hotkey true keys.F6 (modifiers.Fn + modifiers.Control);
		# "12"  = hotkey true keys.F1 (modifiers.Fn + modifiers.Control);
		# "13"  = hotkey true keys.F7 (modifiers.Fn + modifiers.Control);
		# "15"  = hotkey false keys.Number8 (modifiers.Option + modifiers.Command);
		# "17"  = hotkey false 61 24 (modifiers.Option + modifiers.Command);
		# "19"  = hotkey false 45 27 (modifiers.Option + modifiers.Command);
		# "21"  = hotkey true keys.Number8 (modifiers.Control + modifiers.Option + modifiers.Command);
		# "23"  = hotkey false 92 42 (modifiers.Option + modifiers.Command);
		# "25"  = hotkey true 46 47 (modifiers.Control + modifiers.Option + modifiers.Command);
		# "26"  = hotkey true 44 43 (modifiers.Control + modifiers.Option + modifiers.Command);
		# "27"  = hotkey true 96 50 modifiers.Command;
		# "28"  = hotkey true 51 20 (modifiers.Shift + modifiers.Command);
		# "29"  = hotkey true 51 20 (modifiers.Shift + modifiers.Control + modifiers.Command);
		# "30"  = hotkey true 52 21 (modifiers.Shift + modifiers.Command);
		# "31"  = hotkey true 52 21 (modifiers.Shift + modifiers.Control + modifiers.Command);
		# "32"  = hotkey false 126 (modifiers.Fn + modifiers.Control);
		# "33"  = { enabled = false; };
		# "34"  = hotkey false 126 (modifiers.Fn + modifiers.Shift + modifiers.Control);
		# "35"  = { enabled = false; };
		# "36"  = { enabled = false; };
		# "37"  = { enabled = false; };
		# "45"  = { enabled = false; };
		# "47"  = { enabled = false; };
		# "48"  = { enabled = false; };
		# "49"  = { enabled = false; };
		# "52"  = hotkey false 100 2 (modifiers.Option + modifiers.Command);
		# "57"  = hotkey true 100 (modifiers.Fn + modifiers.Control);
		# "59"  = hotkey true 96 (modifiers.Fn + modifiers.Command);
		# "60"  = hotkey true 96 50 (modifiers.Shift + modifiers.Control);
		# "61"  = hotkey false 32 49 (modifiers.Control + modifiers.Option);
		# "64"  = hotkey true 49 modifiers.Command;
		# "65"  = hotkey true 49 (modifiers.Option + modifiers.Command);
		"79"  = hotkey false keys.LeftArrow (modifiers.Shift + modifiers.Option);
		"80"  = hotkey false keys.LeftArrow (modifiers.Shift + modifiers.Control + modifiers.Option);
		"81"  = hotkey false keys.RightArrow (modifiers.Shift + modifiers.Option);
		"82"  = hotkey false keys.RightArrow (modifiers.Shift + modifiers.Control + modifiers.Option);
		# "98"  = hotkey true 47 44 (modifiers.Shift + modifiers.Command);
		# "118" = hotkey false 18 modifiers.Control;
		# "119" = hotkey false 19 modifiers.Control;
		# "160" = hotkey false keys.None modifiers.None;
		# "162" = hotkey true keys.F5 (modifiers.Fn + modifiers.Option + modifiers.Command);
		# "163" = hotkey false keys.None modifiers.None;
		# "164" = { enabled = true; value = { parameters = [ 262144 4294705151 ]; type = "modifiers"; }; };
		# "175" = hotkey false keys.None modifiers.None;
		# "179" = hotkey false keys.None modifiers.None;
		# "181" = hotkey true 54 22 (modifiers.Shift + modifiers.Command);
		# "182" = hotkey true 54 22 (modifiers.Shift + modifiers.Control + modifiers.Command);
		# "184" = hotkey true 53 23 (modifiers.Shift + modifiers.Command);
		# "190" = hotkey true 113 12 modifiers.Fn;
		# "222" = hotkey true keys.None modifiers.None;
	};

	system.pmset = {
		all = {
			autorestart = 1;
			displaysleep = 2;
			hibernatemode = 0;
			highstandbythreshold = 50;
			lidwake = 1;
			standbydelay = 86400;
			standbydelayhigh = 3600;
			standbydelaylow = 900;
		};
		battery = {
			sleep = 5;
		};
		charger = {
			sleep = 0;
		};
	};

	# Used for backwards compatibility, please read the changelog before changing.
	# $ darwin-rebuild changelog
	system.stateVersion = 4;
}
