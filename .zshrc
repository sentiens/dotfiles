autoload -Uz +X compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit

source "./.zshrc.private"

export GOPATH=$HOME/Projects/Go
export GOBIN=$GOPATH/bin

export CARGO_PATH="/Users/user/.cargo/bin"

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
else
  echo "WARNING: atuin command not found. Please install atuin to use this plugin."
fi

LOCAL_BIN=$HOME/.bin

export PATH="$LOCAL_BIN:$CARGO_PATH:$GOBIN:$PATH"

export EDITOR='nvim'

alias vi=nvim
alias vim=nvim
alias @tx=tmuxinator start
alias @src='source ~/.zshrc'
alias @gp='git push'
alias @gpl='git pull'
alias @gs='git status'
alias @gc='git commit -m'

export enhancd_enable_single_dot=0
export ENHANCD_ENABLE_DOUBLE_DOT=0
export ENHANCD_ARG_DOUBLE_DOT="..."

export ZPLUG_HOME=/usr/local/opt/zplug
if [ -f "$ZPLUG_HOME/init.sh" ]; then
    source $ZPLUG_HOME/init.zsh
    zplug "b4b4r07/enhancd", use:init.sh
    zplug "mafredri/zsh-async", from:github
    zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
    zplug "zsh-users/zsh-syntax-highlighting", defer:2
    zplug "zsh-users/zsh-autosuggestions"
    zplug "marlonrichert/zsh-autocomplete"
    zplug load

    zstyle ':completion:*' menu select
    bindkey -M menuselect '\r' .accept-line
else
    echo "Warning: zplug not found, so no plugins"
fi

