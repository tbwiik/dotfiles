#!/usr/bin/env bash

# Setup SSH keys and config for the user
set -e

# Prompt for GitHub email
read -p "Enter your GitHub email: " github_email
if [ -z "$github_email" ]; then
    echo "Error: GitHub email is required"
    exit 1
fi

ssh_dir="$HOME/.ssh"
config_file="$ssh_dir/config"

# Create .ssh directory if it doesn't exist
if [ ! -d "$ssh_dir" ]; then
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
fi

# Generate SSH key if it doesn't exist
key_file="$ssh_dir/id_ed25519"
if [ ! -f "$key_file" ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -f "$key_file" -N "" -C "$github_email"
    echo "SSH key generated at $key_file"
else
    echo "SSH key already exists at $key_file"
fi

# Set proper permissions
chmod 600 "$key_file"
chmod 644 "$key_file.pub"

# Create SSH config if it doesn't exist
if [ ! -f "$config_file" ]; then
    echo "Creating SSH config..."
    cat > "$config_file" << 'EOF'
# Default settings for all hosts
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519

# GitHub
Host github.com
    AddKeysToAgent yes
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519
EOF
    chmod 600 "$config_file"
    echo "SSH config created at $config_file"
else
    echo "SSH config already exists at $config_file"
fi

# Add SSH key to agent
echo "Adding SSH key to agent..."
eval "$(ssh-agent -s)" > /dev/null
ssh-add --apple-use-keychain "$key_file" 2>/dev/null || ssh-add "$key_file"

echo ""
echo "SSH setup complete!"
echo "Your public key:"
cat "$key_file.pub"
echo ""
echo "Copy the above key to add it to GitHub, GitLab, or other services."
