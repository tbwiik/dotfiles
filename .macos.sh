#!/bin/sh
changed=0

set_default() {
  local domain="$1"
  local key="$2"
  local type="$3"
  local value="$4"
  local current
  
  current=$(defaults read "$domain" "$key" 2>/dev/null || echo "unset")
  if [ "$current" != "$value" ]; then
    defaults write "$domain" "$key" "-$type" "$value"
    changed=1
  fi
}

# Dock
set_default com.apple.dock autohide bool true

# Trackpad & Mouse
set_default com.apple.AppleMultitouchTrackpad Clicking bool true
set_default com.apple.AppleMultitouchTrackpad TrackpadRightClick bool true
set_default NSGlobalDomain com.apple.mouse.tapBehavior int 1
set_default com.apple.AppleMultitouchTrackpad TrackpadScrollDirection bool true

# Keyboard behavior
set_default NSGlobalDomain ApplePressAndHoldEnabled bool false
set_default NSGlobalDomain KeyRepeat int 2
set_default NSGlobalDomain InitialKeyRepeat int 15

# Text behavior
set_default NSGlobalDomain AppleShowAllExtensions bool true
set_default NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled bool false
set_default NSGlobalDomain NSAutomaticDashSubstitutionEnabled bool false
set_default NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool false

# Security: password timing
set_default com.apple.screensaver askForPassword int 1
set_default com.apple.screensaver askForPasswordDelay int 3

# Finder
set_default com.apple.finder AppleShowAllFiles bool true
set_default com.apple.finder FXPreferredViewStyle string Nlsv
set_default com.apple.finder DisableAllAnimations bool true

# Restart services only if something changed
if [ "$changed" -eq 1 ]; then
  killall Dock Finder SystemUIServer 2>/dev/null
  echo "macOS defaults updated. Changes may require logout/login to take full effect."
else
  echo "No changes needed."
fi

