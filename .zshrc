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

export enhancd_enable_single_dot=0
export ENHANCD_ENABLE_DOUBLE_DOT=0
export ENHANCD_ARG_DOUBLE_DOT="..."
export EDITOR='nvim'

alias vi=nvim
alias vim=nvim
alias mux=tmuxinator
alias mup=tmuxinator start

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
