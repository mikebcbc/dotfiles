# MCO's dotfiles

Cross-platform dotfiles for Linux (CachyOS or Ubuntu + Hyprland) and macOS (OmniWM). Uses [dotbot](https://github.com/anishathalye/dotbot) for symlinks and package installation.

## What's in here

| Directory | Contents | Platform |
|-----------|----------|----------|
| `nvim/` | Neovim (i use neovim btw) config | both |
| `ghostty/` | Ghostty terminal config | both |
| `fish/` | Fish shell config + fisher plugins | both |
| `git/` | Git config | both |
| `lazygit/` | Lazygit config | both |
| `fastfetch/` | Fastfetch config | both |
| `hypr/` | Hyprland Lua config (0.55+) | Linux |
| `karabiner/` | Karabiner config | macOS |
| `omniwm/` | OmniWM (Hypr dwindle mock on macOS) | macOS |
| `Raycast.rayconfig` | Raycast launcher config | macOS |

## Install

```bash
./install
```

The `install` script runs dotbot which:

1. **Symlinks** shared configs (`install.conf.yaml`): fish, nvim, ghostty, git, fastfetch
1. **Runs** `scripts/install-packages.sh` to install OS-appropriate packages
1. **Symlinks** OS-specific configs (`install-linux.conf.yaml` or `install-macos.conf.yaml`)

On **Ubuntu 26.04 Server** (preferred) or Desktop, `./install` also runs [Hyprbuntu](https://gitlab.com/kralos/hyprbuntu) (Hyprland from source) unless `Hyprland` is already on PATH (set `FORCE_HYPRBUNTU=1` to rebuild). It installs [UWSM](https://wiki.hypr.land/Useful-Utilities/Systemd-start/) from apt (same `uwsm app --` launches as Cachy), [Noctalia](https://docs.noctalia.dev/noctalia/getting-started/installation/) + [Noctalia Greeter](https://docs.noctalia.dev/greeter/) from the official APT repo, then points `~/.config/hypr` at this repo so `hypr/config/autostart.lua` starts Noctalia. Waybar, tuigreet, hyprlock, and hyprpaper are skipped because Noctalia owns those. After first login: Noctalia Settings → Security → Noctalia Greeter → **Sync Now**. Confirm the greeter session name with `noctalia-greeter sessions` if the picker is empty.

On macOS, after install:

1. Karabiner-Elements → Complex Modifications → Add rule → enable **Linux Ctrl app shortcuts on macOS**.
1. System Settings → Keyboard → Keyboard Shortcuts → Mission Control → turn off **Move left a space** and **Move right a space** (Ctrl+Left / Ctrl+Right).

### Packages installed

**Linux CachyOS/Arch (pacman + AUR):**
neovim, bob, fish, ghostty, brave-browser, fastfetch, fisher, fish-pure-prompt, fish-autopair, bat, eza, fd, ripgrep, fzf, lazygit, git, tealdeer, btop, filezilla, satty, yay + autojump (AUR via yay)

**Linux Ubuntu 26.04:**
Hyprland via Hyprbuntu; Noctalia + noctalia-greeter from pkg.noctalia.dev; same CLI/apps as CachyOS (neovim, bob + nightly, fish, ghostty, brave, fastfetch, fisher + pure/autopair, bat, eza, fd, ripgrep, fzf, lazygit, git, tealdeer, btop, filezilla, satty, autojump) plus dolphin and gnome-calculator for Hyprland binds. `yay` is Arch-only.

**macOS (brew formulae + casks):**
neovim, bob, autojump, bat, btop, direnv, eza, fastfetch, fd, fish, fisher, fzf, git, lazygit, ripgrep, tealdeer + brave-browser, filezilla, ghostty, karabiner-elements, omniwm

### Fisher plugins

Plugins are listed in `fish/fish_plugins` and managed by fisher:
`jorgebucaran/fisher`, `edc/bass`, `fisherman/done`, `fabioantunes/fish-nvm`, `patrickf1/fzf.fish`

On CachyOS, `done` and `pure` come from distro packages (`fish-done` and `fish-pure-prompt`). On Ubuntu and macOS, fisher installs `done` and `pure-fish/pure`.

## Cherry-picking CachyOS upstream config changes

Some CachyOS packages like `cachyos-hypr-noctalia` and fish install its config to `/etc/skel/.config/` - the skeleton directory used when creating new user accounts. It never touches an existing `~/.config/` after a package update.

Therefore, package updates are completely decoupled from the active config. To compare upstream changes against the repo copy after a package update:

```bash
diff /etc/skel/.config/hypr/config/binds.lua ~/dotfiles/hypr/config/binds.lua
```

From there, we can manually merge any desired upstream changes into this repo if they're useful.
