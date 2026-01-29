#!/usr/bin/env bash

# Startup script for setting up macOS with your .dotfiles

# Exit on error
set -e

# Variables
dotfiles_dir="$HOME/.dotfiles"
brewfile="$dotfiles_dir/.Brewfile"
ohmyzsh_dir="$HOME/.oh-my-zsh"

# Function to print messages
info() {
    printf "\033[1;34m[INFO]\033[0m %s\n" "$1"
}

# Ask for sudo password upfront
if sudo -v; then
    info "Sudo credentials cached."
else
    echo "Sudo authentication failed."
    exit 1
fi

# Keep sudo alive while script runs
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# 1. Install Xcode Command Line Tools if not installed
if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    # Wait until installation finishes
    read -p "Press [Enter] once Xcode CLI Tools are installed..."
else
    info "Xcode Command Line Tools already installed."
fi

# 2. Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    info "Homebrew already installed."
fi

# 3. Install Brewfile packages
if [ -f "$brewfile" ]; then
    info "Installing Homebrew packages from .Brewfile..."
    brew bundle --file="$brewfile"
else
    info ".Brewfile not found. Skipping package installation."
fi

# 4. Install Oh My Zsh
if [ ! -d "$ohmyzsh_dir" ]; then
    info "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    info "Oh My Zsh already installed."
fi

# 5. Install Oh My Zsh plugins and themes
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_plugin() {
    local name="$1"
    local repo="$2"
    local target="$ZSH_CUSTOM/plugins/$name"

    if [ ! -d "$target" ]; then
        info "Installing zsh plugin: $name"
        git clone --depth=1 "$repo" "$target"
    else
        info "zsh plugin '$name' already installed."
    fi
}

install_theme() {
    local name="$1"
    local repo="$2"
    local target="$ZSH_CUSTOM/themes/$name"

    if [ ! -d "$target" ]; then
        info "Installing zsh theme: $name"
        git clone --depth=1 "$repo" "$target"
    else
        info "zsh theme '$name' already installed."
    fi
}

# Plugins
install_plugin "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions.git"

install_plugin "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"

install_plugin "zsh-completions" \
    "https://github.com/zsh-users/zsh-completions.git"

# Theme
install_theme "powerlevel10k" \
    "https://github.com/romkatv/powerlevel10k.git"

# 6. Symlink dotfiles
symlink_dotfile() {
    local filename="$1"
    local src="$dotfiles_dir/$filename"
    local dest="$HOME/$filename"

    if [ ! -e "$src" ]; then
        info "Source file $src does not exist. Skipping."
        return
    fi

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$src" ]; then
            info "$dest already symlinked correctly."
            return
        else
            info "$dest is a symlink pointing elsewhere. Removing and re-linking."
            rm "$dest"
        fi
    elif [ -e "$dest" ]; then
        info "$dest already exists. Backing up to $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    ln -s "$src" "$dest"
    info "Symlinked $src -> $dest"
}

info "Linking dotfiles..."
symlink_dotfile ".zshrc"
symlink_dotfile ".aliases"
symlink_dotfile ".gitconfig"
symlink_dotfile ".gitignore_global"
symlink_dotfile ".vimrc"

# 7. Apply macOS defaults if provided by the dotfiles
macos_script="$dotfiles_dir/.macos.sh"

if [ -f "$macos_script" ]; then
    info "Applying macOS defaults from $macos_script..."
    chmod +x "$macos_script"
    sh "$macos_script" || info "macOS defaults script exited with a non-zero status."
else
    info ".macos.sh not found. Skipping macOS defaults."
fi

info "Setup complete! Restart your terminal or source your .zshrc: source ~/.zshrc"
