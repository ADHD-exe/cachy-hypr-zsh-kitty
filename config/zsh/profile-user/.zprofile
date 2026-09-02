# profile-user/.zprofile — login shells only, reached via $ZDOTDIR/.zprofile
#
# On this box a login shell is RARE. greetd + uwsm start Hyprland, so the
# graphical session's environment comes from uwsm (~/.config/uwsm/env), not
# from zsh; and kitty spawns /bin/zsh NON-login. That leaves only a raw TTY
# login or an explicit `zsh -l` running this file.
#
# => Nothing essential may live here. Put it where it will actually run:
#      every shell  ->  env-path/.zenv   (the zshenv)
#      interactive  ->  .zshrc
#      GUI session  ->  ~/.config/uwsm/env
#
# /etc/zsh/zprofile has already run /etc/profile by this point, which APPENDS
# /usr/local/sbin:/usr/local/bin:/usr/bin. Our ~/.local/bin is prepended in
# .zenv so it still wins — but any future PATH entry that must beat /usr/bin
# belongs here, after /etc/profile, rather than in .zenv.

# ── Ensure XDG dirs exist ──────────────────────────────────
# Cheap, and only on real logins. $LESSHISTFILE (set in .zapps) lives under
# XDG_STATE_HOME/less, hence that directory.
mkdir -p \
  "$XDG_STATE_HOME/less" \
  "$XDG_CACHE_HOME" \
  "$XDG_DATA_HOME" \
  2>/dev/null

# ── Deliberately NOT here ──────────────────────────────────
# ssh-agent: an agent started here is invisible to GUI-launched terminals,
#   which is nearly all of them on this box. The correct route is
#     systemctl --user enable --now ssh-agent.service
#   plus SSH_AUTH_SOCK in ~/.config/uwsm/env.
# dbus / pipewire / gnome-keyring: started by systemd --user and uwsm.
# HiDPI + Qt/GDK scaling: belongs in ~/.config/uwsm/env, where GUI apps see it.
# pyenv/nodenv/rbenv: none installed; they also need to run for non-login
#   interactive shells, so .zshrc would be their home, not this file.
