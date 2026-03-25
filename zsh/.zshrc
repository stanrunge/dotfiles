# Oh my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
DEFAULT_USER="$USER"
CASE_SENSITIVE="false"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# Platform
IS_MAC=false
IS_LINUX=false
if [[ "$(uname)" == "Darwin" ]]; then
  IS_MAC=true
elif [[ "$(uname)" == "Linux" ]]; then
  IS_LINUX=true
fi


# Path
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
if [ -s "$HOME/.bun/bin/bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi
if [ -s "$HOME/.deno/bin/deno" ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi
if $IS_MAC; then
  export PATH="/Applications/Docker.app/Contents/Resources/bin/:$PATH"
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
  export PATH="/opt/homebrew/opt/curl/bin:$PATH"
  if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  fi
  if [ -d "$HOME/.docker/completions" ]; then
    fpath=($HOME/.docker/completions $fpath)
  fi
fi

# Environment
export EDITOR='nvim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export AWS_REGION=eu-west-1

# --- Clipboard helper ---
# Usage: echo "text" | clip    OR    clip < file.txt
# Usage: clippaste              (paste from clipboard)
# Works on: macOS, Wayland, X11, WSL
if command -v pbcopy &>/dev/null; then
  alias clip='pbcopy'
  alias clippaste='pbpaste'
elif command -v wl-copy &>/dev/null; then
  alias clip='wl-copy'
  alias clippaste='wl-paste'
elif command -v xclip &>/dev/null; then
  alias clip='xclip -selection clipboard'
  alias clippaste='xclip -selection clipboard -o'
elif command -v clip.exe &>/dev/null; then
  alias clip='clip.exe'
  alias clippaste='powershell.exe -c Get-Clipboard'
fi

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias mkdir='mkdir -pv'
alias grip='grep -i'
alias sudo='sudo '

alias gs='git status'
alias gd='git diff'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gp='git pull'
alias gP='git push'
alias gl='git log --oneline --graph --decorate'

alias lg='lazygit'
alias dc='docker compose'
alias tks='tmux kill-session'

DOTFILES_TMUX="$HOME/dev/stan/dotfiles/tmux/.tmux"
alias ve="$DOTFILES_TMUX/vash-esports.sh"
alias pw="$DOTFILES_TMUX/personal-website.sh"

[ -f "$HOME/enable-dns-blocker" ] && alias edb='sudo ~/enable-dns-blocker'
[ -f "$HOME/disable-dns-blocker" ] && alias ddb='sudo ~/disable-dns-blocker'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Completions
autoload -Uz compinit && compinit
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
if command -v terraform &>/dev/null; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C terraform terraform
fi
if command -v rbenv &>/dev/null; then
  eval "$(rbenv init - zsh)"
fi

# macos extras
if $IS_MAC; then
  # iTerm2 shell integration
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

  # Ultrawide monitor presets (displayplacer)
  if command -v displayplacer &>/dev/null; then
    alias ultrawide='displayplacer "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:2056x1329 hz:120 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:A7A6E5A5-DB66-43EC-9786-114B1BDA7323 res:5120x1440 hz:240 color_depth:8 enabled:true scaling:off origin:(-1516,-1440) degree:0"'
    alias halfwide='displayplacer "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:2056x1329 hz:120 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:A7A6E5A5-DB66-43EC-9786-114B1BDA7323 res:2560x1440 hz:120 color_depth:8 enabled:true scaling:off origin:(-1516,-1440) degree:0"'
  fi
fi

# Enable aliases to be sudo'ed.
alias sudo='sudo '


# Copy the contents of all files in a directory to clipboard
# Usage: dumpdir                (current dir)
#        dumpdir ./src          (specific dir)
#        dumpdir . ts,lua       (only .ts and .lua files)
dumpdir() {
  local dir="${1:-.}"
  local extensions="${2:-}"

  local files
  if git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
    files=$(git -C "$dir" ls-files --cached --others --exclude-standard)
  else
    files=$(find "$dir" -type f -not -path '*/.git/*')
  fi

  # Filter by extensions if provided (comma-separated)
  if [ -n "$extensions" ]; then
    local filtered=""
    IFS=',' read -rA exts <<< "$extensions"
    while IFS= read -r f; do
      for ext in "${exts[@]}"; do
        ext=$(echo "$ext" | xargs)
        if [[ "$f" == *."$ext" ]]; then
          filtered+="$f"$'\n'
          break
        fi
      done
    done <<< "$files"
    files="${filtered%$'\n'}"
  fi

  # Build output with tree overview + file contents
  local output
  local file_count=0
  local abs_dir=$(cd "$dir" && pwd)

  output="<directory path=\"$abs_dir\">"$'\n'

  # Tree overview for structure context
  output+=$'\n'"<tree>"$'\n'
  output+=$(echo "$files" | sort | while IFS= read -r f; do
    [ -z "$f" ] && continue
    local filepath="$dir/$f"
    [ -f "$filepath" ] || continue
    echo "$f"
  done)
  output+=$'\n'"</tree>"$'\n'

  # File contents with xml delimiters
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    local filepath="$dir/$f"
    [ -f "$filepath" ] || continue
    # Skip binary files
    if file "$filepath" | grep -qE 'binary|executable|image|font|archive|compressed'; then
      continue
    fi
    output+=$'\n'"<file path=\"$f\">"$'\n'
    output+=$(cat "$filepath" 2>/dev/null)
    output+=$'\n'"</file>"$'\n'
    ((file_count++))
  done <<< "$(echo "$files" | sort)"

  output+=$'\n'"</directory>"

  local line_count=$(echo "$output" | wc -l)
  echo "$output" | clip
  echo "Copied $file_count files ($line_count lines) from $abs_dir to clipboard"
}

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

# prettyread() {
#   local term_width
#   term_width = $(tput cols)

#   local text_width = 80

#   local left_margin = $(( (term_width - text_width) / 2 ))

#   col -bx | fmt -w "$text_width" | sed "s/^/$(printf '%*s' "$left_margin")/" | less
# }
