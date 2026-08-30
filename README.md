# MCO's dotfiles

Cross-platform dotfiles for Linux (CachyOS w/ Hyprland) and Mac (macOS w/ HyprMac). Uses [dotbot](https://github.com/anishathalye/dotbot) for symlinks and package installation.

## What's in here

| Directory | Contents | Platform |
|-----------|----------|----------|
| `nvim/` | Neovim (i use neovim btw) config | both |
| `ghostty/` | Ghostty terminal config | both |
| `fish/` | Fish shell config + fisher plugins | both |
| `git/` | Git config | both |
| `lazygit/` | Lazygit config | both |
| `fastfetch/` | Fastfetch config with ASCII art that I spent too much time on | both |
| `hypr/` | Hyprland config | Linux |
| `Raycast.rayconfig` | Raycast launcher config | macOS |

## Install

```bash
./install
```

The `install` script runs dotbot which:

1. **Symlinks** shared configs (`install.conf.yaml`): fish, nvim, ghostty, git, fastfetch
3. **Symlinks** OS-specific configs (`install-linux.conf.yaml` or `install-macos.conf.yaml`)
2. **Runs** `scripts/install-packages.sh` to install OS-appropriate packages

### Packages installed

**Linux (pacman + AUR):**
neovim, bob, fish, ghostty, brave-browser, fastfetch, fisher, fish-pure-prompt, fish-autopair, bat, eza, fd, ripgrep, fzf, lazygit, git, tealdeer, btop, filezilla, satty, yay + autojump (AUR via yay)

**macOS (brew formulae + casks):**
neovim, bob, autojump, bat, btop, direnv, eza, fastfetch, fd, fish, fisher, fzf, git, lazygit, ripgrep, tealdeer (formulae) + brave-browser, filezilla, ghostty, hyprmac (casks)

### Fisher plugins

Plugins are listed in `fish/fish_plugins` and managed by fisher:
`jorgebucaran/fisher`, `edc/bass`, `fisherman/done`, `fabioantunes/fish-nvm`, `patrickf1/fzf.fish`

On Linux, `done` and `pure` come from CachyOS packages (`fish-done` and `fish-pure-prompt`). On macOS, fisher installs `done`, `pure-fish/pure`.

## Cherry-picking CachyOS upstream config changes

Some CachyOS packages like `cachyos-hypr-noctalia` and fish install its config to `/etc/skel/.config/` - the skeleton directory used when creating new user accounts. It never touches an existing `~/.config/` after a package update.

Therefore, package updates are completely decoupled from the active config. To compare upstream changes against the repo copy after a package update:

```bash
diff /etc/skel/.config/hypr/config/binds.lua ~/dotfiles/hypr/config/binds.lua
```

From there, we can manually merge any desired upstream changes into this repo if they're useful.
