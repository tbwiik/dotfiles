#!/bin/sh

changed=0

set_bool() {
  domain="$1"
  key="$2"
  value="$3"

  current=$(defaults read "$domain" "$key" 2>/dev/null || echo "unset")
  if [ "$current" != "$value" ]; then
    defaults write "$domain" "$key" -bool "$value"
    changed=1
  fi
}

set_int() {
  domain="$1"
  key="$2"
  value="$3"

  current=$(defaults read "$domain" "$key" 2>/dev/null || echo "unset")
  if [ "$current" != "$value" ]; then
    defaults write "$domain" "$key" -int "$value"
    changed=1
  fi
}

set_string() {
  domain="$1"
  key="$2"
  value="$3"

  current=$(defaults read "$domain" "$key" 2>/dev/null || echo "unset")
  if [ "$current" != "$value" ]; then
    defaults write "$domain" "$key" -string "$value"
    changed=1
  fi
}

# Dock
set_bool com.apple.dock autohide true

# Trackpad: tap-to-click
set_bool com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking true
set_int  NSGlobalDomain com.apple.mouse.tapBehavior 1

# Security: password timing
set_int  com.apple.screensaver askForPassword 1
set_int  com.apple.screensaver askForPasswordDelay 3

# Keyboard behavior
set_bool NSGlobalDomain ApplePressAndHoldEnabled false
set_int  NSGlobalDomain KeyRepeat 2
set_int  NSGlobalDomain InitialKeyRepeat 15

# Text behavior
set_bool NSGlobalDomain AppleShowAllExtensions true
set_bool NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled false
set_bool NSGlobalDomain NSAutomaticDashSubstitutionEnabled false

# Finder
set_bool   com.apple.finder AppleShowAllFiles true
set_string com.apple.finder FXPreferredViewStyle Nlsv
set_bool   com.apple.finder DisableAllAnimations true

# Restart services only if something changed
if [ "$changed" -eq 1 ]; then
  killall Dock Finder SystemUIServer 2>/dev/null
fi
