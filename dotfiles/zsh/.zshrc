# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/mahi/.zsh/completions:"* ]]; then export FPATH="/home/mahi/.zsh/completions:$FPATH"; fi
export ZSH="$HOME/.oh-my-zsh"

# Plugins
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# aliases
alias zc="vi ~/.zshrc"
alias zs="source ~/.zshrc"
alias tc="vi ~/.config/tmux/tmux.conf.local"
alias ls="exa"
alias ll="exa -la"
alias setup="vi ~/Documents/Coding/Projects/setup-files/"
alias note="~/Documents/Coding/Projects/setup-files/scripts/quick-note.sh"
alias wick="~/Documents/Coding/Projects/setup-files/scripts/tmux-wick.sh"
alias vi="~/Documents/Coding/Projects/setup-files/scripts/vi.sh"

# starship
eval "$(starship init zsh)"

# fzf search
source <(fzf --zsh)

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt extendedhistory
setopt histignorealldups
setopt histignorespace
setopt histignoredups
setopt histreduceblanks

# pnpm
export PNPM_HOME="/home/mahi/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=$HOME/.local/bin:$PATH

# android studio
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit

# fnm
FNM_PATH="/home/mahi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mahi/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
