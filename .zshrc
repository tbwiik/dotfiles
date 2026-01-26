# ---------------------------
# 1. Oh My Zsh
# ---------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source "$ZSH/oh-my-zsh.sh"


# ---------------------------
# 2. Completion system (recommended)
# ---------------------------
autoload -Uz compinit
compinit


# ---------------------------
# 3. Powerlevel10k configuration
# ---------------------------
# Generated on first run via: p10k configure
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# ---------------------------
# 4. Environment & PATH
# ---------------------------
# Homebrew (Apple Silicon default)
if [ -d /opt/homebrew/bin ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# ---------------------------
# 5. Aliases
# ---------------------------
# Loaded via Oh My Zsh automatically if present,
# but sourced explicitly for clarity
[[ -f ~/.aliases ]] && source ~/.aliases


# ---------------------------
# 6. Optional tool integrations
# ---------------------------
# Uncomment if you use direnv
# eval "$(direnv hook zsh)"

# Uncomment if you use fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# ---------------------------
# 7. History configuration
# ---------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY


# ---------------------------
# 8. Colors and ls behavior
# ---------------------------
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced


# ---------------------------
# 9. End of .zshrc
# ---------------------------
