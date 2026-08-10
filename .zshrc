# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)
source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Editor defaults (NvChad)
export EDITOR=nvim
export VISUAL=nvim
alias vim=nvim
alias vi=nvim

# Homebrew (Apple Silicon)
if command -v brew &> /dev/null; then
  eval "$(brew shellenv)"
fi

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ripgrep + FZF
if command -v rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  export FZF_DEFAULT_OPTS='--multi --height 50%'
fi

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS
setopt SHARE_HISTORY INC_APPEND_HISTORY

# Terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Development aliases (extend in ~/.aliases if needed)
[[ -f ~/.aliases ]] && source ~/.aliases

