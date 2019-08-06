#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

echo "Customizing macOS system settings..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "
defaults write .GlobalPreferences com.apple.sound.beep.sound /System/Library/Sounds/Tink.aiff
defaults write .GlobalPreferences com.apple.sound.beep.volume -float 0.0

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g QLPanelAnimationDuration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
sudo defaults write com.apple.universalaccess reduceMotion -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable smart quotes/dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Enable full keyboard access for all UI controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable three-finger drag (now accessibility feature)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
sudo defaults write bluetoothaudiod "Enable AAC codec" -bool true
sudo defaults write bluetoothaudiod "Enable AptX codec" -bool true

echo "Customizing macOS screen capture settings ..."
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

echo "Customizing macOS finder settings ..."
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 1.0
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
defaults write com.apple.helpviewer DevMode -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" \
    ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" \
    ~/Library/Preferences/com.apple.finder.plist

chflags nohidden ~/Library
sudo chflags nohidden /Volumes
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

echo "Customizing macOS dock settings ..."
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true

defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide -bool true

defaults write com.apple.dock showLaunchpadGestureEnabled -int 0
defaults write com.apple.dock showDesktopGestureEnable -int 0
defaults write com.apple.dock showMissionControlGestureEnabled -int 0

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool true

# Reset Launchpad
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete

echo "Customizing macOS various application settings ..."
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 5
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true

defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

defaults write com.apple.ActivityMonitor SortColumn -string "CPUTime"
defaults write com.apple.ActivityMonitor SortDirection -int 0
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "Customizing Mail application settings ..."
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"
defaults write com.apple.mail SendFormat -string "Plain"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.mail ConversationViewMarkAllAsRead -bool true
defaults write com.apple.mail ConversationViewSortDescending -bool true
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
defaults write com.apple.mail NumberOfSnippetLines -int 1
sudo defaults write com.apple.mail-shared DisableURLLoading -bool true
sudo defaults write com.apple.mail-shared ExpandPrivateAliases -bool true

defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.1
defaults write com.apple.Safari WebKitResourceTimedLayoutDelay 0.1

# Disable Preview's page scaling on printing
defaults write com.apple.Preview PVImagePrintingScaleMode 0
defaults write com.apple.Preview PVImagePrintingAutoRotate 0
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "Customizing Chrome application settings ..."
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool true
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool true
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

echo "Customizing Skitch application settings ..."
defaults write com.skitch.skitch HasAskedToKeepHelperRunningInBackground -bool true
defaults write com.skitch.skitch StartHelperAtLogin -bool false
defaults write com.skitch.skitch KeepHelperRunningInBackground -bool false

echo "Customizing Fantastical application settings ..."
defaults write com.flexibits.fantastical2.mac DaysPerWeek -int 14
defaults write com.flexibits.fantastical2.mac WeekViewStartsWith -int 0
defaults write com.flexibits.fantastical2.mac WeeksPerMonth -int 8
defaults write com.flexibits.fantastical2.mac FirstWeekday -int 2
defaults write com.flexibits.fantastical2.mac ListShows -int 2
defaults write com.flexibits.fantastical2.mac HoursToShow -int 18
defaults write com.flexibits.fantastical2.mac StatusItemBadge -string "StatusItemStyleDateAndWeekday"
defaults write com.flexibits.fantastical2.mac ColorStatusItem -bool false
defaults write com.flexibits.fantastical2.mac LightTheme -bool true
defaults write com.flexibits.fantastical2.mac IgnoreQuitWarning -bool true
defaults write com.flexibits.fantastical2.mac ShowCalendarWeeks -bool true
defaults write com.flexibits.fantastical2.mac CombineIdenticalItems -bool true
defaults write com.flexibits.fantastical2.mac HockeySDKAutomaticallySendCrashReports -bool false
defaults write com.flexibits.fantastical2.mac HockeySDKCrashReportActivated -bool false
defaults write com.flexibits.fantastical2.mac SUEnableAutomaticChecks -bool true

echo "Customizing Spotify client application settings ..."
defaults write com.spotify.client run_mode -string "clean_quit"
defaults write com.spotify.client AutoStartSettingIsHidden -bool false