# Bootstrap only. This is the one zsh dotfile that has to live directly in
# $HOME — zsh reads .zshenv via $HOME, not $ZDOTDIR, since ZDOTDIR isn't known
# yet at this point. Everything else (.zshrc, aliases, plugins, etc.) is
# sourced from the project at $ZDOTDIR below.
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/env-path/.zenv"
