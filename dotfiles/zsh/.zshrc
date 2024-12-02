# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/mahi/.zsh/completions:"* ]]; then export FPATH="/home/mahi/.zsh/completions:$FPATH"; fi
export ZSH="$HOME/.oh-my-zsh"
# Plugins
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# aliases
alias zc="nvim ~/.zshrc"
alias zs="source ~/.zshrc"
alias ls="exa"
alias ll="exa -la"
alias ac="nvim ~/.config/alacritty/alacritty.toml"
alias setup="code /mnt/Base/Coding/Misc/setup"
# starship
eval "$(starship init zsh)"
# fnm
export PATH="/home/mahi/.local/share/fnm:$PATH"
eval "$(fnm env)"

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

# fnm
FNM_PATH="/home/mahi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mahi/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
# android studio
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# fnm
FNM_PATH="/home/mahi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mahi/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# fnm
FNM_PATH="/home/mahi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mahi/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

. "/home/mahi/.deno/env"
# fnm
FNM_PATH="/home/mahi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mahi/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# fnm
FNM_PATH="/home/mahi/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mahi/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit