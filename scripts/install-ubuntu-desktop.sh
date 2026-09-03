#!/usr/bin/env bash
# Ubuntu Server or Desktop: Hyprbuntu (Hyprland from source) + official Noctalia + Greeter.
# Server is the intended ISO (no GNOME). Desktop works too; GDM is disabled.
# https://gitlab.com/kralos/hyprbuntu
# https://docs.noctalia.dev/noctalia/getting-started/installation/
# https://docs.noctalia.dev/greeter/
#
# Safe to re-run. Does not replace macOS or CachyOS/Arch paths.

set -euo pipefail

if [[ "$(uname)" != "Linux" ]]; then
    echo "install-ubuntu-desktop.sh is Linux-only."
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
if [[ "${ID:-}" != "ubuntu" && "${ID_LIKE:-}" != *ubuntu* && "${ID_LIKE:-}" != *debian* ]]; then
    echo "This script is for Ubuntu/Debian. Detected ID=${ID:-unknown}."
    exit 1
fi

if [[ "${VERSION_ID:-}" != "26.04" && "${VERSION_CODENAME:-}" != "resolute" ]]; then
    echo "Warning: Hyprbuntu and the Noctalia Ubuntu APT repo target Ubuntu 26.04."
    echo "You are on ${PRETTY_NAME:-unknown}. Continuing anyway."
fi

echo "=== Enabling universe (needed on Ubuntu Server) ==="
if ! command -v add-apt-repository >/dev/null; then
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
fi
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository -y universe
sudo apt-get update

echo "=== CLI packages (apt, matching CachyOS) ==="
# Same set as the Arch path in install-packages.sh (yay is Arch-only).
# dolphin + gnome-calculator are what hypr/config/variables.lua launches.
APT_PKGS=(
    git
    curl
    wget
    unzip
    fish
    neovim
    bat
    eza
    fzf
    ripgrep
    fd-find
    lazygit
    tealdeer
    btop
    filezilla
    fastfetch
    autojump
    direnv
    ghostty
    dolphin
    gnome-calculator
    libgtk-4-1
    libadwaita-1-0
    # binds.lua uses `uwsm app --`; greeter default is Hyprland (uwsm-managed).
    # Hyprbuntu only builds uwsm when TUIGREET_SETUP=true, which we skip.
    uwsm
)

sudo apt-get install -y "${APT_PKGS[@]}"

mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
export PATH="$HOME/.local/bin:${PATH}"

if ! command -v brave-browser >/dev/null; then
    echo "=== Brave ==="
    curl -fsS https://dl.brave.com/install.sh | sh || echo "Brave install failed — install later."
fi

if ! command -v bob >/dev/null; then
    echo "=== bob (Neovim version manager) ==="
    curl -fsSL https://raw.githubusercontent.com/MordechaiHadad/bob/master/scripts/install.sh | bash
fi

if ! command -v satty >/dev/null; then
    echo "=== satty (GitHub release; not in Ubuntu repos) ==="
    case "$(uname -m)" in
        x86_64) satty_arch="x86_64" ;;
        aarch64|arm64) satty_arch="aarch64" ;;
        *) satty_arch="" ;;
    esac
    if [[ -n "$satty_arch" ]]; then
        satty_tmp="$(mktemp -d)"
        satty_tarball="satty-${satty_arch}-unknown-linux-gnu.tar.gz"
        if curl -fsSL -o "$satty_tmp/$satty_tarball" \
            "https://github.com/Satty-org/Satty/releases/latest/download/${satty_tarball}"; then
            tar -xzf "$satty_tmp/$satty_tarball" -C "$satty_tmp"
            satty_bin="$(find "$satty_tmp" -type f -name satty | head -n 1)"
            if [[ -n "$satty_bin" ]]; then
                install -m 0755 "$satty_bin" "$HOME/.local/bin/satty"
            else
                echo "satty binary not found in archive — install later."
            fi
        else
            echo "satty download failed — install later."
        fi
        rm -rf "$satty_tmp"
    else
        echo "No satty binary for $(uname -m) — install later."
    fi
fi

# Hyprbuntu writes a real ~/.config/hypr directory. Replace it with this repo
# so hyprland.lua + config/autostart.lua (noctalia) are what Hyprland loads.
link_hypr_config() {
    local src dest
    src="$(cd "$(dirname "$0")/.." && pwd)/hypr"
    dest="$HOME/.config/hypr"
    if [[ ! -d "$src" ]]; then
        echo "Warning: $src not found — cannot link Hyprland config."
        return 1
    fi
    mkdir -p "$HOME/.config"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "Replacing $dest with symlink to $src"
        rm -rf "$dest"
    fi
    ln -sfn "$src" "$dest"
    echo "Hyprland config: $dest -> $(readlink "$dest")"
}

if [[ "${FORCE_HYPRBUNTU:-}" != "1" ]] && command -v Hyprland >/dev/null; then
    echo "=== Hyprland already installed — skipping Hyprbuntu compile ==="
    Hyprland --version 2>/dev/null || true
    echo "Set FORCE_HYPRBUNTU=1 to rebuild from source."
else
    echo "=== Hyprbuntu (Hyprland + ecosystem from source) ==="
    # Noctalia owns the bar, notifications, lock, wallpaper, and OSDs.
    HYPRBUNTU_SETUP_PATH="$HOME/.local/bin"
    mkdir -p "$HYPRBUNTU_SETUP_PATH"
    curl -fsSL -o "$HYPRBUNTU_SETUP_PATH/setup-hyprbuntu.sh" \
        "https://gitlab.com/kralos/hyprbuntu/-/raw/main/setup-hyprbuntu.sh"
    chmod +x "$HYPRBUNTU_SETUP_PATH/setup-hyprbuntu.sh"

    THEME_PREF=dark \
        NOTIFICATION_DAEMON_PREF=none \
        HYPRPAPER_SETUP=false \
        HYPRLOCK_SETUP=false \
        HYPRIDLE_SETUP=false \
        HYPRSHOT_SETUP=false \
        SWAYOSD_SETUP=false \
        THUNAR_SETUP=true \
        WAYBAR_SETUP=false \
        TUIGREET_SETUP=false \
        DISABLE_CONFIRM=true \
        "$HYPRBUNTU_SETUP_PATH/setup-hyprbuntu.sh"
fi

echo "=== Noctalia + Noctalia Greeter (official APT repo) ==="
# https://docs.noctalia.dev/noctalia/getting-started/installation/ — Ubuntu 26.04
if [[ ! -f /etc/apt/sources.list.d/noctalia-resolute.sources ]]; then
    tmp_key="$(mktemp)"
    wget -q -O "$tmp_key" https://pkg.noctalia.dev/deb/nickh-archive-keyring.deb
    sudo dpkg -i "$tmp_key"
    rm -f "$tmp_key"
    sudo wget -q -O /etc/apt/sources.list.d/noctalia-resolute.sources \
        https://pkg.noctalia.dev/deb/noctalia-resolute.sources
    sudo apt update
fi
sudo apt install -y noctalia noctalia-greeter accountsservice polkitd || \
    sudo apt install -y noctalia noctalia-greeter

if systemctl list-unit-files gdm.service >/dev/null 2>&1 || systemctl list-unit-files gdm3.service >/dev/null 2>&1; then
    echo "=== Switching login from GDM to greetd + Noctalia Greeter ==="
    sudo systemctl disable --now gdm.service 2>/dev/null || true
    sudo systemctl disable --now gdm3.service 2>/dev/null || true
fi

SESSION_WRAPPER="$(command -v noctalia-greeter-session || true)"
if [[ -z "$SESSION_WRAPPER" ]]; then
    SESSION_WRAPPER="/usr/bin/noctalia-greeter-session"
fi

sudo mkdir -p /etc/greetd
if [[ ! -f /etc/greetd/config.toml ]] || ! grep -q noctalia-greeter-session /etc/greetd/config.toml 2>/dev/null; then
    sudo tee /etc/greetd/config.toml >/dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "${SESSION_WRAPPER}"
user = "greeter"
EOF
fi

sudo mkdir -p /var/lib/noctalia-greeter
if [[ ! -f /var/lib/noctalia-greeter/greeter.toml ]]; then
    sudo tee /var/lib/noctalia-greeter/greeter.toml >/dev/null <<'EOF'
[session]
default = "Hyprland (uwsm-managed)"
EOF
    if id greeter >/dev/null 2>&1; then
        sudo chown -R greeter:greeter /var/lib/noctalia-greeter
    fi
fi

sudo systemctl enable greetd.service
sudo systemctl set-default graphical.target
sudo systemctl enable accounts-daemon.service 2>/dev/null || true
sudo systemctl restart greetd.service || true

echo "=== Hyprland config symlink + Noctalia autostart ==="
link_hypr_config
if [[ -f "$HOME/.config/hypr/hyprland.lua" && -f "$HOME/.config/hypr/config/autostart.lua" ]]; then
    echo "Noctalia autostart: hypr/config/autostart.lua (hl.on hyprland.start → noctalia)"
else
    echo "Warning: Hyprland lua config missing after link — Noctalia will not autostart."
fi
if ! command -v noctalia >/dev/null; then
    echo "Warning: noctalia is not on PATH."
fi
if ! command -v uwsm >/dev/null; then
    echo "Warning: uwsm is not on PATH — Super+T/E binds and the uwsm-managed session will fail."
fi

echo
echo "Ubuntu Hyprland pieces are installed."
echo "Reboot and pick Hyprland (uwsm-managed) on the Noctalia greeter."
echo "After first login: Noctalia Settings → Security → Noctalia Greeter → Sync Now."
