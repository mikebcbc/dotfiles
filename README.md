# MCO's dotfiles

Cross-platform dotfiles for Linux (CachyOS or Ubuntu + Hyprland) and macOS (OmniWM).

## Install

```bash
./install
```

`./install` does:

1. Updates git submodules (dotbot)
1. Runs **dotbot** with `install.conf.yaml` - symlinks shared configs and sets up directories
1. Runs **dotbot** with `install-linux.conf.yaml` or `install-macos.conf.yaml` depending on OS
1. Runs **`scripts/install-packages.sh`**
1. sudo-symlinks the Noctalia greeter config on linux since ownership of this file is iffy.

## What's in here

| Directory | Contents | Platform |
|-----------|----------|----------|
| `nvim/` | Neovim config (i use neovim btw) | both |
| `ghostty/` | Ghostty terminal config + Vesper theme | both |
| `fish/` | Fish shell config + fisher plugins | both |
| `git/` | Git config | both |
| `lazygit/` | Lazygit config | both |
| `fastfetch/` | Fastfetch config + custom logo | both |
| `hypr/` | Hyprland Lua config (0.55+) | Linux |
| `noctalia/` | Noctalia shell + greeter config | Linux |
| `wallpapers/` | Wallpaper copied to `~/Pictures/Wallpapers` | Linux |
| `karabiner/` | Karabiner complex modifications | macOS |
| `omniwm/` | OmniWM settings | macOS |
| `Brewfile` | Homebrew bundle (formulae + casks) | macOS |
| `Raycast.rayconfig` | Raycast launcher config | macOS |

## Ubuntu 26.04

On **Ubuntu 26.04 Server**, `install-packages.sh` runs [Hyprbuntu](https://gitlab.com/kralos/hyprbuntu) (Hyprland from source) unless `Hyprland` is already on PATH (set `FORCE_HYPRBUNTU=1` to rebuild). It installs [UWSM](https://wiki.hypr.land/Useful-Utilities/Systemd-start/) from apt, [Noctalia](https://docs.noctalia.dev/noctalia/getting-started/installation/) + [Noctalia Greeter](https://docs.noctalia.dev/greeter/) from the official APT repo, then `./install` symlinks `noctalia/greeter.toml` to `/var/lib/noctalia-greeter/greeter.toml`. We need to sync the greeter manually after logging in.

## macOS

After install:

1. Karabiner-Elements → Complex Modifications → Add rule → enable **Linux Ctrl app shortcuts on macOS**.
1. System Settings → Keyboard → Keyboard Shortcuts → Mission Control → turn off **Move left a space** and **Move right a space** (Ctrl+Left / Ctrl+Right).

## Fisher plugins

Plugins are listed in `fish/fish_plugins` and managed by fisher:
`jorgebucaran/fisher`, `edc/bass`, `fisherman/done`, `fabioantunes/fish-nvm`, `patrickf1/fzf.fish`

On CachyOS, `done` and `pure` come from distro packages (`fish-done` and `fish-pure-prompt`). On Ubuntu and macOS, fisher installs `pure-fish/pure` and `jorgebucaran/autopair.fish`.

## Cherry-picking CachyOS upstream config changes

Some CachyOS packages like `cachyos-hypr-noctalia` install their config to `/etc/skel/.config/` — the skeleton directory used when creating new user accounts. It never touches an existing `~/.config/` after a package update.

To compare upstream changes against the repo copy after a package update:

```bash
diff /etc/skel/.config/hypr/config/binds.lua ~/dotfiles/hypr/config/binds.lua
```
