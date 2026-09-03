#!/usr/bin/env bash
#
# Cross-platform package installer for mikec's dotfiles.
# Detects OS and installs required packages via pacman (CachyOS/Arch),
# apt + Hyprbuntu/Noctalia (Ubuntu), or brew (macOS).
# Skips already-installed packages where possible

set -euo pipefail

OS="$(uname)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# -------------------------------------------------------------------
# Install Inconsolata Nerd Font Mono (used by Noctalia bar/shell)
# -------------------------------------------------------------------
install_font() {
    case "$OS" in
        Linux)
            if [[ "${ID:-}" == "ubuntu" || "${ID_LIKE:-}" == *ubuntu* ]]; then
                FONT_DIR="$HOME/.local/share/fonts"
                mkdir -p "$FONT_DIR"
                if ! fc-list | grep -q "Inconsolata Nerd Font Mono"; then
                    echo "Installing Inconsolata Nerd Font (Ubuntu)..."
                    tmp="$(mktemp -d)"
                    if curl -fsSL -o "$tmp/Inconsolata.zip" \
                        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Inconsolata.zip"; then
                        unzip -oq "$tmp/Inconsolata.zip" -d "$FONT_DIR"
                        fc-cache -f "$FONT_DIR"
                    fi
                    rm -rf "$tmp"
                fi
            fi
            ;;
        Darwin)
            brew install --cask font-inconsolata-nerd-font 2>/dev/null || \
                echo "Warning: font-inconsolata-nerd-font cask failed — install manually."
            ;;
    esac
}

# -------------------------------------------------------------------
# Install wallpaper + Noctalia portable settings (Linux only)
# -------------------------------------------------------------------
install_noctalia_extras() {
    python3 "$SCRIPT_DIR/noctalia-setup.py"
}

# -------------------------------------------------------------------
# Linux — CachyOS/Arch (pacman) or Ubuntu (Hyprbuntu + Noctalia)
# -------------------------------------------------------------------
if [[ "$OS" == "Linux" ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release

    if [[ "${ID:-}" == "ubuntu" || "${ID_LIKE:-}" == *ubuntu* ]]; then
        echo "Detected Ubuntu — Hyprbuntu + Noctalia"
        SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
        "$SCRIPT_DIR/install-ubuntu-desktop.sh"

        export PATH="$HOME/.local/bin:${PATH}"

        if command -v bob &>/dev/null; then
            echo "Setting Neovim to nightly via bob..."
            bob use nightly
        fi

        if command -v fish &>/dev/null; then
            echo "Installing fisher plugins..."
            fish "$SCRIPT_DIR/fisher-install.fish" pure-fish/pure jorgebucaran/autopair.fish
        fi

        install_font
        install_noctalia_extras

        echo "Done."
    else
        echo "Detected Linux - using pacman"

        PACMAN_PKGS=(
            neovim
            bob
            fish
            ghostty
            brave-browser
            fastfetch
            fisher
            fish-pure-prompt
            fish-autopair
            ttf-inconsolata-nerd
            bat
            eza
            fd
            ripgrep
            fzf
            lazygit
            git
            tealdeer
            btop
            filezilla
            satty
            yay
        )

        # AUR packages (installed via yay)
        AUR_PKGS=(
            autojump
        )

        echo "Installing: ${PACMAN_PKGS[*]}"
        sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

        if [[ ${#AUR_PKGS[@]} -gt 0 ]]; then
            echo "Installing AUR: ${AUR_PKGS[*]}"
            if command -v yay &>/dev/null; then
                yay -S --needed --noconfirm "${AUR_PKGS[@]}"
            else
                echo "yay not found — skipping AUR packages"
            fi
        fi

        if command -v bob &>/dev/null; then
            echo "Setting Neovim to nightly via bob..."
            bob use nightly
        fi

        # Install fisher plugins from fish_plugins
        if command -v fish &>/dev/null; then
            echo "Installing fisher plugins..."
            fish "$(dirname "$0")/fisher-install.fish"
        fi

        install_noctalia_extras

        echo "Done."
    fi
fi

# -------------------------------------------------------------------
# macOS - Homebrew
# -------------------------------------------------------------------
if [[ "$OS" == "Darwin" ]]; then
    echo "Detected macOS - using brew"

    # Install Homebrew if not present
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Formulae (CLI tools)
    BREW_PKGS=(
        neovim
        bob
        autojump
        bat
        btop
        direnv
        eza
        fastfetch
        fd
        fish
        fisher
        fzf
        git
        lazygit
        ripgrep
        tealdeer
    )

    # Fix Homebrew permissions if some directories are owned by root
    # (e.g. from a previous sudo brew or formula that created dirs as root)
    if find /opt/homebrew/lib -maxdepth 1 -user root -print -quit 2>/dev/null | grep -q .; then
        echo "Fixing Homebrew permissions (some directories owned by root)..."
        sudo chown -R "$(whoami):admin" /opt/homebrew
    fi

    echo "Installing formulae: ${BREW_PKGS[*]}"
    brew install "${BREW_PKGS[@]}"

    # Casks (GUI apps) - install individually so one failure doesn't block others
    CASK_PKGS=(
        brave-browser
        filezilla
        ghostty
        karabiner-elements
        BarutSRB/tap/omniwm
    )

    for cask in "${CASK_PKGS[@]}"; do
        echo "Installing cask: $cask"
        brew install --cask "$cask" || echo "Warning: failed to install cask '$cask' — continuing"
    done

    if command -v bob &>/dev/null; then
        echo "Setting Neovim to nightly via bob..."
        bob use nightly
    fi

    # Install fisher plugins from fish_plugins, plus pure-fish/pure on macOS (since we don't want this one in the file because CachyOS ships a version)
    if command -v fish &>/dev/null; then
        echo "Installing fisher plugins..."
        fish "$(dirname "$0")/fisher-install.fish" pure-fish/pure
    fi

    install_font

    echo "Done."
fi
