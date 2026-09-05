#!/usr/bin/env bash
#
# Cross-platform package installer for mikec's dotfiles.
# Detects OS and installs required packages via pacman (CachyOS/Arch),
# apt + Hyprbuntu/Noctalia (Ubuntu), or brew (macOS).
# Skips already-installed packages where possible.
# Collects all errors and prints them in red at the end.

set -uo pipefail

OS="$(uname)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ERRORS=()
FISHER_EXTRA=()

add_error() {
    ERRORS+=("$1")
}

RED='\033[0;31m'
NC='\033[0m'

print_errors() {
    if [[ ${#ERRORS[@]} -gt 0 ]]; then
        echo ""
        echo -e "${RED}=== Errors (${#ERRORS[@]}) ===${NC}"
        for err in "${ERRORS[@]}"; do
            echo -e "${RED}  - ${err}${NC}"
        done
        echo ""
    fi
}

trap print_errors EXIT

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
                    else
                        add_error "Failed to download Inconsolata Nerd Font — install manually from https://www.nerdfonts.com/font-downloads"
                    fi
                    rm -rf "$tmp"
                fi
            fi
            ;;
        Darwin)
            brew install --cask font-inconsolata-nerd-font 2>/dev/null || \
                add_error "Failed to install font-inconsolata-nerd-font cask — run 'brew install --cask font-inconsolata-nerd-font' manually."
            ;;
    esac
}

# -------------------------------------------------------------------
# Set fish as default shell (non-fatal, Linux only)
# -------------------------------------------------------------------
set_default_shell() {
    local fish_path
    fish_path="$(command -v fish 2>/dev/null)" || return 0
    if [[ "$SHELL" != "$fish_path" ]]; then
        echo "Setting fish as default shell..."
        chsh -s "$fish_path" 2>/dev/null || \
            add_error "chsh failed — run 'sudo chsh -s $fish_path \$USER' manually."
    fi
}

# -------------------------------------------------------------------
# Shared post-install: bob, fisher, shell, font
# -------------------------------------------------------------------
post_install() {
    if command -v bob &>/dev/null; then
        echo "Setting Neovim to nightly via bob..."
        bob use nightly || add_error "bob use nightly failed."
    fi

    if command -v fish &>/dev/null; then
        echo "Installing fisher plugins..."
        fish "$SCRIPT_DIR/fisher-install.fish" "${FISHER_EXTRA[@]}" || \
            add_error "fisher plugin installation failed."
    fi

    set_default_shell
    install_font
    echo "Done."
}

# -------------------------------------------------------------------
# Linux — CachyOS/Arch (pacman) or Ubuntu (Hyprbuntu + Noctalia)
# -------------------------------------------------------------------
if [[ "$OS" == "Linux" ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release

    if [[ "${ID:-}" == "ubuntu" || "${ID_LIKE:-}" == *ubuntu* ]]; then
        echo "Detected Ubuntu — Hyprbuntu + Noctalia"
        "$SCRIPT_DIR/install-ubuntu-desktop.sh" || add_error "install-ubuntu-desktop.sh failed — check output above."
        export PATH="$HOME/.local/bin:${PATH}"
        FISHER_EXTRA=("pure-fish/pure" "jorgebucaran/autopair.fish")
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
            tree-sitter-cli
        )

        # AUR packages (installed via yay)
        AUR_PKGS=(
            autojump
        )

        echo "Installing: ${PACMAN_PKGS[*]}"
        sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}" || \
            add_error "pacman install failed — some packages may not be installed."

        if [[ ${#AUR_PKGS[@]} -gt 0 ]]; then
            echo "Installing AUR: ${AUR_PKGS[*]}"
            if command -v yay &>/dev/null; then
                yay -S --needed --noconfirm "${AUR_PKGS[@]}" || \
                    add_error "yay install failed — some AUR packages may not be installed."
            else
                add_error "yay not found — AUR packages (${AUR_PKGS[*]}) not installed."
            fi
        fi
    fi

    post_install
fi

# -------------------------------------------------------------------
# macOS - Homebrew
# -------------------------------------------------------------------
if [[ "$OS" == "Darwin" ]]; then
    echo "Detected macOS - using brew"

    # Install Homebrew if not present
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || \
            { add_error "Homebrew installation failed."; exit 1; }
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Fix Homebrew permissions if some directories are owned by root
    # (e.g. from a previous sudo brew or formula that created dirs as root)
    if find /opt/homebrew/lib -maxdepth 1 -user root -print -quit 2>/dev/null | grep -q .; then
        echo "Fixing Homebrew permissions (some directories owned by root)..."
        sudo chown -R "$(whoami):admin" /opt/homebrew || \
            add_error "Failed to fix Homebrew permissions — run 'sudo chown -R \$(whoami):admin /opt/homebrew' manually."
    fi

    # Install all formulae + casks from Brewfile
    BREWFILE="${BASE_DIR:-$(cd "$(dirname "$0")/.." && pwd)}/Brewfile"
    echo "Installing from Brewfile..."
    brew bundle --file "$BREWFILE" || \
        add_error "brew bundle failed — some packages may not be installed. Run 'brew bundle --file $BREWFILE' manually."

    FISHER_EXTRA=("pure-fish/pure")
    post_install
fi
