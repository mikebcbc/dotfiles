#!/usr/bin/env bash
#
# Cross-platform package installer for mikec's dotfiles.
# Detects OS and installs required packages via pacman (Linux) or brew (macOS).
# Skips already-installed packages where possible

set -euo pipefail

OS="$(uname)"

# -------------------------------------------------------------------
# Linux (CachyOS / Arch) - pacman
# -------------------------------------------------------------------
if [[ "$OS" == "Linux" ]]; then
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
        fish -c 'fisher update'
    fi

    echo "Done."
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

    echo "Installing formulae: ${BREW_PKGS[*]}"
    brew install "${BREW_PKGS[@]}"

    # Casks (GUI apps)
    CASK_PKGS=(
        brave-browser
        filezilla
        ghostty
        zacharytgray/hyprmac/hyprmac
    )

    echo "Installing casks: ${CASK_PKGS[*]}"
    brew install --cask "${CASK_PKGS[@]}"

    if command -v bob &>/dev/null; then
        echo "Setting Neovim to nightly via bob..."
        bob use nightly
    fi

    # Install fisher plugins from fish_plugins, plus pure-fish/pure on macOS (since we don't want this one in the file because CachyOS ships a version)
    if command -v fish &>/dev/null; then
        echo "Installing fisher plugins..."
        fish -c 'fisher update && fisher install pure-fish/pure'
    fi

    echo "Done."
fi
