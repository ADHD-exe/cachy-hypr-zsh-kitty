# Entry point zsh actually reads for login shells — zsh looks for
# $ZDOTDIR/.zprofile and nothing else, so the real content has to be reachable
# from here. Same pattern as ~/.zshenv -> env-path/.zenv.
source "$ZDOTDIR/profile-user/.zprofile"
