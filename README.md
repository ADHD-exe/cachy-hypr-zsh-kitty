# cachy-hypr-zsh-kitty

Dotfiles for a CachyOS box running Hyprland (under greetd + uwsm) with kitty as
the terminal and a framework-free zsh setup.

## Layout

Directories mirror where files actually go, so deploying is a copy with no
guesswork about destinations:

```
config/     ->  ~/.config/
home/       ->  ~/
```

| Path | Goes to | What it is |
|---|---|---|
| `config/zsh/` | `~/.config/zsh/` | The whole zsh config (this is `$ZDOTDIR`) |
| `config/kitty/` | `~/.config/kitty/` | kitty terminal + themes |
| `config/hypr/` | `~/.config/hypr/` | Hyprland, split into `config/*.lua` modules |
| `config/atuin/` | `~/.config/atuin/` | atuin history config + theme |
| `config/uwsm/` | `~/.config/uwsm/` | Graphical-session environment (see below) |
| `config/btop/` | `~/.config/btop/` | btop + theme |
| `config/starship.toml` | `~/.config/starship.toml` | Prompt |
| `home/.zshenv` | `~/.zshenv` | **Bootstrap — sets `ZDOTDIR`. Nothing works without it.** |
| `home/.p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k config, kept as a fallback; not loaded |

## Install

```sh
git clone git@github.com:ADHD-exe/cachy-hypr-zsh-kitty.git
cd cachy-hypr-zsh-kitty
cp -r config/. ~/.config/
cp home/.zshenv home/.p10k.zsh ~/
chsh -s /bin/zsh          # if zsh isn't already the login shell
```

`~/.zshenv` is the one file that must live in `$HOME`: zsh reads it before it
knows what `ZDOTDIR` is, and it is what points zsh at `~/.config/zsh`.

## How the zsh config loads

zsh reads its startup files in a fixed order, and each file here has exactly one
job. Putting something in the wrong one is the main way this config breaks.

```
~/.zshenv                    every shell   sets ZDOTDIR, sources env-path/.zenv
  └─ env-path/.zenv          every shell   exports + PATH ONLY. No output, nothing slow.
/etc/zsh/zprofile            login only    (system) runs /etc/profile
$ZDOTDIR/.zprofile           login only    stub -> profile-user/.zprofile
$ZDOTDIR/.zshrc              interactive   everything below
  ├─ apps-plugins/.zapps                   EDITOR/VISUAL, XDG-ifying rc files
  ├─ banner-prompt/.zprompt                starship
  ├─ banner-prompt/.zbanner                fastfetch (interactive-guarded)
  ├─ history-completions/.zhistory         HISTFILE, HISTSIZE, setopts
  ├─ compinit
  ├─ aliases-functions/.zfunctions         shell functions
  ├─ aliases-functions/.zalias             ~420 aliases
  └─ apps-plugins/.zplugins                third-party plugins, staged
```

Two rules that follow from this:

- **`.zenv` runs for scripts and `zsh -c` too.** Anything that prints, or that
  costs more than a few ms, does not belong there. `zsh -c 'echo clean'` should
  print exactly `clean`.
- **`.zprofile` is nearly empty on purpose.** greetd + uwsm start Hyprland, so
  the graphical session's environment comes from `config/uwsm/env`, not zsh —
  and kitty spawns a *non-login* shell. A login shell therefore only happens on
  a raw TTY or `zsh -l`, so nothing load-bearing can live there. Session-wide
  environment variables go in `config/uwsm/env`.

### Plugins

The oh-my-zsh *framework* is not used — no `$ZSH`, no `oh-my-zsh.sh`, no omz
compinit. Individual omz plugin files are sourced directly, which works for all
of them and keeps startup around 60 ms.

| Plugin | Source |
|---|---|
| colored-man-pages, extract, sudo | `/usr/share/oh-my-zsh/plugins/` |
| you-should-use, zsh-bat | `/usr/share/oh-my-zsh/custom/plugins/` |
| zsh-autosuggestions, zsh-history-substring-search | pacman |
| fast-syntax-highlighting, fzf-tab | vendored in `~/.local/share/zsh/plugins/` |
| fzf, zoxide, yazi, atuin | native integration in `.zplugins` |

Deliberately **not** loaded, with the reasoning kept in `.zplugins`:

- **omz `git`** — `.zalias` section 5 already carries 42 git aliases extracted
  from it; the plugin would stack 204 more onto the same names.
- **omz `z`** — zoxide is the maintained rewrite and already provides `z`.
- **omz `fzf`** — it only locates an fzf install and sources the same two files
  that `.zplugins` points at directly.

### Keybindings worth knowing

| Key | Action |
|---|---|
| `Ctrl-R` | fzf history search |
| `↑` / `↓` | history-substring-search |
| `Ctrl-Z` | fzf-tab complete-word |
| `Esc Esc` | prepend `sudo` to the current line |

## Requirements

```sh
# core
sudo pacman -S zsh zsh-autosuggestions zsh-history-substring-search \
               zsh-completions oh-my-zsh starship kitty hyprland uwsm btop

# tools the aliases and functions call
sudo pacman -S fzf zoxide bat eza duf ripgrep yazi fastfetch \
               grim slurp wl-clipboard neovim expac
```

Vendored (no official-repo package — clone to `~/.local/share/zsh/plugins/`):

```sh
git clone https://github.com/Aloxaf/fzf-tab       ~/.local/share/zsh/plugins/fzf-tab
git clone https://github.com/z-shell/F-Sy-H       ~/.local/share/zsh/plugins/fast-syntax-highlighting
```

Cloned into `/usr/share/oh-my-zsh/custom/plugins/`:
[you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use),
[zsh-bat](https://github.com/fdellwing/zsh-bat).

## Known gaps

These are real and unresolved, not TODO filler:

- **atuin is not installed.** `.zplugins` has a guarded init block that
  activates on its own once it exists: `sudo pacman -S atuin && atuin import auto`.
  Note `config/atuin/config.toml` points `db_path` at
  `~/.config/zsh/history-completions/atuin/history.db`, a directory that does not
  currently exist — create it or change the path before first run.
- **`config/hypr/hyprland.conf` is empty (1 byte)** while the real settings live
  in `hyprland.lua` + `config/*.lua`. Hyprland 0.56.2 does not read Lua natively
  and no generator script was found, so how (or whether) the Lua tree is applied
  is unverified. Check this before relying on the Hyprland config.
- **`config/starship.toml`** was carried over from a different machine and has
  not been reviewed.
- **swappy is not installed**, so the `ssedit` screenshot function in
  `.zfunctions` errors out despite its `grim`/`slurp` guard passing.
- **fastfetch has no config file** and runs on defaults.

## Not in this repo

Excluded by `.gitignore`, deliberately:

- `*.bak` files. `kitty.conf.bak` contained a `remote_control_password` in
  plaintext; hypr keeps timestamped `.bak` copies of `binds.lua` and
  `monitors.lua`.
- `.zsh_history`, `.zcompdump*`, `*.zwc`, and any `*.db` — machine-local state,
  and shell history can contain anything you have ever typed.
