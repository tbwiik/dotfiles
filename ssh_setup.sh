#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Simple, idempotent SSH setup for GitHub (macOS friendly)
# Usage: ssh_setup.sh [-f] [-k key_file] [-l label] [-t key_type] [-n]
#  -f : force overwrite existing key
#  -k : key file path (default: $HOME/.ssh/id_ed25519)
#  -l : key comment/label (default: "github")
#  -t : key type (default: ed25519)
#  -n : no-copy (don't copy pubkey to clipboard)

FORCE=0
KEY_FILE="$HOME/.ssh/id_ed25519"
KEY_LABEL=""
KEY_TYPE="ed25519"
DO_COPY=1

print_usage() {
  cat <<EOF
Usage: $0 [-f] [-k key_file] [-l label] [-t key_type] [-n]
  -f  Force overwrite existing key
  -k  Key file path (default: $HOME/.ssh/id_ed25519)
  -l  Key label/comment (default: github)
  -t  Key type (default: ed25519)
  -n  Don't copy public key to clipboard
EOF
}

while getopts ":fk:l:t:n" opt; do
  case $opt in
    f) FORCE=1 ;;
    k) KEY_FILE="$OPTARG" ;;
    l) KEY_LABEL="$OPTARG" ;;
    t) KEY_TYPE="$OPTARG" ;;
    n) DO_COPY=0 ;;
    *) print_usage; exit 1 ;;
  esac
done

# Prompt for key label if not provided and running in an interactive terminal
if [ -z "$KEY_LABEL" ]; then
  if [ -t 0 ]; then
    read -rp "Enter key label (comment) [github]: " input_label
    KEY_LABEL="${input_label:-github}"
  else
    KEY_LABEL="github"
  fi
fi

SSH_DIR="$HOME/.ssh"
SSH_CONFIG="$SSH_DIR/config"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ -f "$KEY_FILE" ] && [ "$FORCE" -ne 1 ]; then
  echo "Key already exists at $KEY_FILE"
  echo "Run with -f to overwrite or choose a different -k path."
  exit 0
fi

if [ -f "$KEY_FILE" ] && [ "$FORCE" -eq 1 ]; then
  echo "Overwriting existing key at $KEY_FILE"
  rm -f "$KEY_FILE" "$KEY_FILE.pub"
fi

echo "Generating SSH key: type=$KEY_TYPE label=$KEY_LABEL file=$KEY_FILE"
ssh-keygen -t "$KEY_TYPE" -C "$KEY_LABEL" -f "$KEY_FILE"

# Start ssh-agent if not already running
if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
  eval "$(ssh-agent -s)" >/dev/null
fi

# Add key to agent, prefer macOS keychain option when supported
if ssh-add --help 2>&1 | grep -q -- '--apple-use-keychain'; then
  ssh-add --apple-use-keychain "$KEY_FILE" || ssh-add "$KEY_FILE"
else
  ssh-add "$KEY_FILE"
fi

# Ensure SSH config has a Host block for github.com
GITHUB_BLOCK="Host github.com
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_FILE"

if [ -f "$SSH_CONFIG" ]; then
  if grep -q "^Host github.com" "$SSH_CONFIG"; then
    echo "SSH config already contains github.com host block; leaving unchanged."
  else
    printf "\n%s\n" "$GITHUB_BLOCK" >> "$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
    echo "Appended github.com host block to $SSH_CONFIG"
  fi
else
  printf "%s\n" "$GITHUB_BLOCK" > "$SSH_CONFIG"
  chmod 600 "$SSH_CONFIG"
  echo "Created $SSH_CONFIG with github.com host block"
fi

# Copy public key to clipboard if possible
if [ "$DO_COPY" -eq 1 ]; then
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy < "$KEY_FILE.pub"
    echo "Public key copied to clipboard."
  else
    echo "pbcopy not found; public key is at: $KEY_FILE.pub"
    echo "Public key contents:"
    cat "$KEY_FILE.pub"
  fi
else
  echo "Public key written to $KEY_FILE.pub"
fi

echo "You can test the SSH connection with: ssh -T git@github.com"

