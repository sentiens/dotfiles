# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

autoload -Uz compinit
compinit

source "./.zshrc.private"

export GOPATH=$HOME/Projects/Go
export GOBIN=$GOPATH/bin
export GOROOT=/usr/local/opt/go/libexec

export CARGO_PATH="/Users/user/.cargo/bin"
export BREW_PATH="/usr/local/sbin"

eval "$(atuin init zsh --disable-up-arrow)"
export PATH="$CARGO_PATH:$BREW_PATH:$GOBIN:$PATH"

export EDITOR='nvim'

alias vi=nvim
alias vim=nvim
alias mux=tmuxinator
alias mup=tmuxinator start
alias src='source ~/.zshrc'

export enhancd_enable_single_dot=0
export ENHANCD_ENABLE_DOUBLE_DOT=0
export ENHANCD_ARG_DOUBLE_DOT="..."

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "b4b4r07/enhancd", use:init.sh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "marlonrichert/zsh-autocomplete", defer:2

zplug load

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
