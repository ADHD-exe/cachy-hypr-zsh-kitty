# ================================== ZSHRC =================================
# Interactive shells only. Env + PATH already ran via ~/.zshenv -> env-path/.zenv
# before this file, so nothing here needs to source them again.
#
# Login-only setup lives in profile-user/.zprofile (reached via $ZDOTDIR/.zprofile).

## ================================ APPS ================================
## Tool env (EDITOR, VISUAL, XDG-ifying rc files) — must precede anything
## that reads $EDITOR.
source $ZDOTDIR/apps-plugins/.zapps

## ============================ PROMPT + BANNER ============================
source $ZDOTDIR/banner-prompt/.zprompt
source $ZDOTDIR/banner-prompt/.zbanner

## ========================= HISTORY + COMPLETIONS =========================
source $ZDOTDIR/history-completions/.zhistory

autoload -Uz compinit
compinit -d "$ZDOTDIR/history-completions/zsh/.zcompdump"

## ========================== ALIASES + FUNCTIONS ==========================
source $ZDOTDIR/aliases-functions/.zfunctions
source $ZDOTDIR/aliases-functions/.zalias

## =============================== PLUGINS ===============================
## Last: .zplugins stages completion-dependent tools (fzf-tab) and
## fast-syntax-highlighting, which must wrap every other widget.
source $ZDOTDIR/apps-plugins/.zplugins
