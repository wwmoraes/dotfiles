#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${DEFAULTS:=0}"

if [ ${DEFAULTS} -eq 1 ]; then
	printf "\e[1;33mDarwin defaults\e[0m\n"

	# sane defaults on https://github.com/kevinSuttle/macOS-Defaults

	# close system preferences to avoid it overriding any settings done here
	osascript -e 'tell application "System Preferences" to quit'

	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until the parent has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# disable system policy (i.e. allow apps from anywhere)
	sudo spctl --master-enable

	###############################################################################
	### UI/UX
	###############################################################################

	# disable the sound effects on boot
	sudo nvram SystemAudioVolume=" "

	# disable transparency in the menu bar and elsewhere on Yosemite
	sudo defaults write com.apple.universalaccess reduceTransparency -bool true

	# set sidebar icon size to medium
	defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

	# only show scrollbars when scrolling
	defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

	# disable the over-the-top focus ring animation
	defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

	# enable smooth scrolling
	defaults write NSGlobalDomain NSScrollAnimationEnabled -bool true

	# increase window resize speed for Cocoa applications
	defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

	# expand save panel by default
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

	# expand print panel by default
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

	# save to disk (not to iCloud) by default
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	# automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

	# disable the “Are you sure you want to open this application?” dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	# remove duplicates in the “Open With” menu (also see `lscleanup` alias)
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

	# display ASCII control characters using caret notation in standard text views
	# try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
	defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

	# Disable Resume system-wide
	# defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

	# Disable automatic termination of inactive apps
	# defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

	# Disable the crash reporter
	#defaults write com.apple.CrashReporter DialogType -string "none"

	# Set Help Viewer windows to non-floating mode
	defaults write com.apple.helpviewer DevMode -bool true

	# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
	# Commented out, as this is known to cause problems in various Adobe apps :(
	# See https://github.com/mathiasbynens/dotfiles/issues/237
	#echo "0x08000100:0" > ~/.CFUserTextEncoding

	# Reveal IP address, hostname, OS version, etc. when clicking the clock
	# in the login window
	sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

	# Disable Notification Center and remove the menu bar icon
	#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

	# use a lighter text rendering style
	defaults write AppleFontSmoothing -int 1

	# disable the animations for opening Quick Look windows
	defaults write QLPanelAnimationDuration -float 0

	# don’t blink the caret (the value is in milliseconds)
	# defaults write NSTextInsertionPointBlinkPeriod -int 9999999999999999

	################################################################################
	### Periphetals
	################################################################################

	# Disable automatic capitalization as it’s annoying when typing code
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

	# Disable smart dashes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

	# Disable automatic period substitution as it’s annoying when typing code
	defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

	# Disable smart quotes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

	# Disable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	# disable checking spelling while typing
	defaults write NSGlobalDomain NSAllowContinuousSpellChecking -bool false

	# Increase sound quality for Bluetooth headphones/headsets
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

	# Enable full keyboard access for all controls
	# (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

	# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

	# Set fast keyboard repeat rate
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# Set language and text formats
	# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
	# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
	defaults write NSGlobalDomain AppleLanguages -array "en-NL" "pt-BR"
	defaults write NSGlobalDomain AppleLocale -string "en_US@currency=EUR"
	defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
	defaults write NSGlobalDomain AppleMetricUnits -bool true

	# Stop iTunes from responding to the keyboard media keys
	launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

	################################################################################
	### Energy saving
	################################################################################

	# Enable lid wakeup
	sudo pmset -a lidwake 1

	# Restart automatically on power loss
	sudo pmset -a autorestart 1

	# Restart automatically if the computer freezes
	sudo systemsetup -setrestartfreeze on

	# Sleep the display after 15 minutes
	sudo pmset -a displaysleep 2

	# Disable machine sleep while charging
	sudo pmset -c sleep 0

	# Set machine sleep to 5 minutes on battery
	sudo pmset -b sleep 5

	# Set standby delay to 24 hours (default is 1 hour)
	sudo pmset -a standbydelay 86400

	# Never go into computer sleep mode
	sudo systemsetup -setcomputersleep Off > /dev/null

	# Hibernation mode
	# 0: Disable hibernation (speeds up entering sleep mode)
	# 3: Copy RAM to disk so the system state can still be restored in case of a
	#    power failure.
	sudo pmset -a hibernatemode 0

	# Remove the sleep image file to save disk space
	test -f /private/var/vm/sleepimage && sudo rm /private/var/vm/sleepimage
	# Create a zero-byte file instead…
	# sudo touch /private/var/vm/sleepimage
	# …and make sure it can’t be rewritten
	# sudo chflags uchg /private/var/vm/sleepimage

	################################################################################
	### Screen
	################################################################################

	# Require password immediately after sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	# Save screenshots to the desktop
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"

	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"

	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true

	# Enable subpixel font rendering on non-Apple LCDs
	# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
	defaults write NSGlobalDomain AppleFontSmoothing -int 1

	# Enable HiDPI display modes (requires restart)
	sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

	################################################################################
	### Finder
	################################################################################

	# set home folder as the default location on new window/tabs
	defaults write com.apple.finder NewWindowTarget -string "PfLo"
	defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

	# show icons for hard drives, servers, and removable media on the desktop
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

	# show hidden files by default
	#defaults write com.apple.finder AppleShowAllFiles -bool true

	# hide all file extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool false

	# show status bar
	defaults write com.apple.finder ShowStatusBar -bool true

	# show path bar
	defaults write com.apple.finder ShowPathbar -bool true

	# Display full POSIX path as Finder window title
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	# Keep folders on top when sorting by name
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	# When performing a search, search the current folder by default
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

	# Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	# Enable spring loading for directories
	defaults write NSGlobalDomain com.apple.springing.enabled -bool true

	# Remove the spring loading delay for directories
	defaults write NSGlobalDomain com.apple.springing.delay -float 0

	# Avoid creating .DS_Store files on network or USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Disable disk image verification
	defaults write com.apple.frameworks.diskimages skip-verify -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

	# Automatically open a new Finder window when a volume is mounted
	defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
	defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
	defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

	# Show item info near icons on the desktop and in other icon views
	# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

	# Show item info to the right of the icons on the desktop
	# /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

	# Enable snap-to-grid for icons on the desktop and in other icon views
	# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

	# Increase grid spacing for icons on the desktop and in other icon views
	# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

	# Increase the size of icons on the desktop and in other icon views
	# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

	# Use list view in all Finder windows by default
	# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

	# Disable the warning before emptying the Trash
	defaults write com.apple.finder WarnOnEmptyTrash -bool false

	# Enable AirDrop over Ethernet and on unsupported Macs running Lion
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

	# always show the user Library folder
	chflags nohidden ~/Library

	# Show the /Volumes folder
	sudo chflags nohidden /Volumes

	# Expand the following File Info panes:
	# “General”, “Open with”, and “Sharing & Permissions”
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
		General -bool true \
		OpenWith -bool true \
		Privileges -bool true

	# enable text selection on QuickLook
	defaults write com.apple.finder QLEnableTextSelection -bool true

	################################################################################
	### Dock, Dashboard, and hot corners
	################################################################################

	# Enable highlight hover effect for the grid view of a stack (Dock)
	defaults write com.apple.dock mouse-over-hilite-stack -bool true

	# Set the icon size of Dock items to 36 pixels
	defaults write com.apple.dock tilesize -int 72

	# Change minimize/maximize window effect
	defaults write com.apple.dock mineffect -string "genie"

	# Minimize windows into their application’s icon
	defaults write com.apple.dock minimize-to-application -bool true

	# Enable spring loading for all Dock items
	defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# show translucent icons for hidden apps
	defaults write com.apple.Dock showhidden -bool yes

	# Speed up Mission Control animations
	defaults write com.apple.dock expose-animation-duration -float 0.1

	# Disable Dashboard
	defaults write com.apple.dashboard mcx-disabled -bool true

	# Don’t show Dashboard as a Space
	defaults write com.apple.dock dashboard-in-overlay -bool true

	# Don’t automatically rearrange Spaces based on most recent use
	defaults write com.apple.dock mru-spaces -bool false

	# Remove the auto-hiding Dock delay
	defaults write com.apple.dock autohide-delay -float 0

	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true

	# Don’t show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false

	################################################################################
	### Safari & WebKit
	################################################################################

	# Privacy: don’t send search queries to Apple
	defaults write com.apple.Safari UniversalSearchEnabled -bool false
	defaults write com.apple.Safari SuppressSearchSuggestions -bool true

	# Press Tab to highlight each item on a web page
	defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

	# Show the full URL in the address bar (note: this still hides the scheme)
	defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

	# Set Safari’s home page to `about:blank` for faster loading
	# defaults write com.apple.Safari HomePage -string "about:blank"

	# Prevent Safari from opening ‘safe’ files automatically after downloading
	defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

	# Allow hitting the Backspace key to go to the previous page in history
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool false

	# Show Safari’s bookmarks bar by default
	defaults write com.apple.Safari ShowFavoritesBar -bool true

	# Show Safari’s sidebar in Top Sites
	defaults write com.apple.Safari ShowSidebarInTopSites -bool true

	# Disable Safari’s thumbnail cache for History and Top Sites
	defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

	# Enable Safari’s debug menu
	defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

	# Make Safari’s search banners default to Contains instead of Starts With
	defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

	# Remove useless icons from Safari’s bookmarks bar
	defaults write com.apple.Safari ProxiesInBookmarksBar "()"

	# Enable the Develop menu and the Web Inspector in Safari
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

	# Add a context menu item for showing the Web Inspector in web views
	defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

	# Enable continuous spellchecking
	defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

	# Disable auto-correct
	defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

	# Disable AutoFill
	defaults write com.apple.Safari AutoFillFromAddressBook -bool false
	defaults write com.apple.Safari AutoFillPasswords -bool false
	defaults write com.apple.Safari AutoFillCreditCardData -bool false
	defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

	# Warn about fraudulent websites
	defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

	# Enable plug-ins
	defaults write com.apple.Safari WebKitPluginsEnabled -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool true

	# Disable Java
	defaults write com.apple.Safari WebKitJavaEnabled -bool false
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

	# Block pop-up windows
	defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

	# Disable auto-playing video
	defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
	defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
	defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

	# Enable “Do Not Track”
	defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

	# Update extensions automatically
	defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

	################################################################################
	### Mail
	################################################################################

	# Disable send and reply animations in Mail.app
	defaults write com.apple.mail DisableReplyAnimations -bool true
	defaults write com.apple.mail DisableSendAnimations -bool true

	# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
	defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

	# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
	defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

	# Display emails in threaded mode, sorted by date (newest at the top)
	defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
	defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
	defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

	# Disable inline attachments (just show the icons)
	defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

	# Disable automatic spell checking
	defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

	################################################################################
	### Spotlight
	################################################################################

	# Disable Spotlight indexing for any volume that gets mounted and not indexed before
	# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

	# Change indexing order and disable some search results
	defaults write com.apple.spotlight orderedItems -array \
		'{"enabled" = 1;"name" = "APPLICATIONS";}' \
		'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
		'{"enabled" = 1;"name" = "DIRECTORIES";}' \
		'{"enabled" = 1;"name" = "PDF";}' \
		'{"enabled" = 1;"name" = "FONTS";}' \
		'{"enabled" = 0;"name" = "DOCUMENTS";}' \
		'{"enabled" = 0;"name" = "MESSAGES";}' \
		'{"enabled" = 0;"name" = "CONTACT";}' \
		'{"enabled" = 0;"name" = "EVENT_TODO";}' \
		'{"enabled" = 0;"name" = "IMAGES";}' \
		'{"enabled" = 0;"name" = "BOOKMARKS";}' \
		'{"enabled" = 0;"name" = "MUSIC";}' \
		'{"enabled" = 0;"name" = "MOVIES";}' \
		'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
		'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
		'{"enabled" = 0;"name" = "SOURCE";}' \
		'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
		'{"enabled" = 0;"name" = "MENU_OTHER";}' \
		'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
		'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
		'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
		'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

	# Load new settings before rebuilding the index
	killall mds > /dev/null 2>&1

	# Make sure indexing is enabled for the main volume
	sudo mdutil -i on / > /dev/null

	# Rebuild the index from scratch
	# sudo mdutil -E / > /dev/null

	################################################################################
	### Terminal
	################################################################################

	# Only use UTF-8 in Terminal.app
	defaults write com.apple.terminal StringEncodings -array 4

	# Enable Secure Keyboard Entry in Terminal.app
	# See: https://security.stackexchange.com/a/47786/8918
	defaults write com.apple.terminal SecureKeyboardEntry -bool true

	# Disable the annoying line marks
	defaults write com.apple.Terminal ShowLineMarks -int 0

	################################################################################
	### TimeMachine
	################################################################################

	# Prevent Time Machine from prompting to use new hard drives as backup volume
	defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

	# Disable local Time Machine backups
	# hash tmutil &> /dev/null && sudo tmutil disablelocal
	hash tmutil &> /dev/null && sudo tmutil thinlocalsnapshots / 1000000000 1 &> /dev/null

	################################################################################
	### Activity Monitor
	################################################################################

	# Show the main window when launching Activity Monitor
	defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

	# Visualize CPU usage in the Activity Monitor Dock icon
	defaults write com.apple.ActivityMonitor IconType -int 5

	# Show all processes in Activity Monitor
	defaults write com.apple.ActivityMonitor ShowCategory -int 0

	# Sort Activity Monitor results by CPU usage
	defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
	defaults write com.apple.ActivityMonitor SortDirection -int 0

	###############################################################################
	# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
	###############################################################################

	# Enable the debug menu in Address Book
	defaults write com.apple.addressbook ABShowDebugMenu -bool true

	# Disable Dashboard dev mode (allows keeping widgets on the desktop)
	defaults write com.apple.dashboard devmode -bool false

	# Enable the debug menu in iCal (pre-10.8)
	defaults write com.apple.iCal IncludeDebugMenu -bool true

	# Use plain text mode for new TextEdit documents
	defaults write com.apple.TextEdit RichText -int 0

	# Open and save files as UTF-8 in TextEdit
	defaults write com.apple.TextEdit PlainTextEncoding -int 4
	defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

	# Enable the debug menu in Disk Utility
	defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
	defaults write com.apple.DiskUtility advanced-image-options -bool true

	# Auto-play videos when opened with QuickTime Player
	defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

	###############################################################################
	# Mac App Store                                                               #
	###############################################################################

	# Enable the WebKit Developer Tools in the Mac App Store
	defaults write com.apple.appstore WebKitDeveloperExtras -bool true

	# Enable Debug Menu in the Mac App Store
	defaults write com.apple.appstore ShowDebugMenu -bool true

	# Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	# Check for software updates daily, not just once per week
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

	# Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

	# Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

	# Automatically download apps purchased on other Macs
	defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

	# Turn on app auto-update
	defaults write com.apple.commerce AutoUpdate -bool true

	# Disable the App Store to reboot machine on macOS updates
	defaults write com.apple.commerce AutoUpdateRestartRequired -bool false

	###############################################################################
	# Photos                                                                      #
	###############################################################################

	# Prevent Photos from opening automatically when devices are plugged in
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

	###############################################################################
	# Messages                                                                    #
	###############################################################################

	# Enable automatic emoji substitution (i.e. don't use plain text smileys)
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool true

	# Disable smart quotes as it’s annoying for messages that contain code
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

	# Disable continuous spell checking
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

	###############################################################################
	# Google Chrome & Google Chrome Canary                                        #
	###############################################################################

	# Disable the all too sensitive backswipe on trackpads
	defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
	defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

	# Disable the all too sensitive backswipe on Magic Mouse
	defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
	defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

	# Use the system-native print preview dialog
	defaults write com.google.Chrome DisablePrintPreview -bool true
	defaults write com.google.Chrome.canary DisablePrintPreview -bool true

	# Expand the print dialog by default
	defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
	defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

	################################################################################
	### Miscellaneous
	################################################################################

	# disable auto-save in AppleScript Editor
	defaults write com.apple.ScriptEditor2 ApplePersistence -bool false

	# disable library validation
	sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true

	# disable system integrity protection on fs, nvram and debug
	# csrutil enable --without fs --without nvram --without debug

	read -r -p 'do you want to kill related applications to load new defaults? [y/N] ' confirm

  if [ -d /System/Library/CoreServices/PowerChime.app ]; then
    printf "Disabling MacOS power chime...\n"
    defaults write com.apple.PowerChime ChimeOnAllHardware -bool false
    killall PowerChime &> /dev/null
  fi

	if [ "${confirm}" == "Y" ] || [ "${confirm}" == "y" ]; then
		for app in "Activity Monitor" \
			"Address Book" \
			"Calendar" \
			"cfprefsd" \
			"Contacts" \
			"Dock" \
			"Finder" \
			"Google Chrome Canary" \
			"Google Chrome" \
			"Mail" \
			"Messages" \
			"Photos" \
			"Safari" \
			"SystemUIServer" \
			"Terminal" \
			"iCal"; do
			killall "${app}" &> /dev/null
		done
	fi
fi
