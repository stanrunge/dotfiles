# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set a faster theme to improve startup time.
ZSH_THEME="agnoster"  # You can change this to another minimal theme if you prefer.
DEFAULT_USER="$USER"

# Enable case-insensitive completion.
CASE_SENSITIVE="false"

# Load only essential plugins to reduce load time.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source Oh My Zsh.
source $ZSH/oh-my-zsh.sh

# User configuration.

# Set up your PATH environment variable.
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Add other paths (e.g., Node.js, Python, etc.).
export PATH="$HOME/.local/bin:$PATH"

export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# Set default editor.
export EDITOR='nvim'  # Change to your preferred editor.

# Language settings.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Aliases for productivity.
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias gd='git diff'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gp='git pull'
alias gP='git push'
alias gl='git log --oneline --graph --decorate'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias mkdir='mkdir -pv'
alias lg='lazygit'
alias dc='docker compose'
alias tks='tmux kill-session'
alias grip='grep -i'

alias ve='~/dev/dotfiles/tmux/vash-esports.sh'
alias rdb='sail artisan migrate:fresh; sail artisan db:seed'
alias vash='sail artisan'
alias ss='~/dev/dotfiles/tmux/stikstof.sh'
alias mko='~/dev/dotfiles/tmux/distributor.sh'
alias pw='~/dev/dotfiles/tmux/personal-website.sh'
alias hai='~/dev/dotfiles/tmux/hair-ai.sh'

# Enable aliases to be sudo'ed.
alias sudo='sudo '

# NVM (Node Version Manager) with lazy loading.
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
if [[ $NVM_LAZY_LOAD == true ]]; then
  nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
fi

# Load Bun if installed.
if [ -s "$HOME/.bun/bin/bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Load Deno if installed.
if [ -s "$HOME/.deno/bin/deno" ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Load kubectl completions on demand.
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

# Load Google Cloud SDK if installed.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

export AWS_REGION=eu-west-1

# Functions for productivity.

# Extract function to handle various archive types.
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via this function" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a directory and navigate into it.
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Git branch in prompt.
parse_git_branch() {
  git branch 2>/dev/null | sed -n '/\* /s///p'
}

# Load zsh-autosuggestions if installed.
if [ -f "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Load zsh-syntax-highlighting if installed.
if [ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# bun completions
[ -s "/Users/stanrunge/.bun/_bun" ] && source "/Users/stanrunge/.bun/_bun"
