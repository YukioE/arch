#!/usr/bin/env bash
set -euo pipefail

REPO_SSH="git@github.com:yukioe/arch.git"
REPO_HTTPS="https://github.com/yukioe/arch.git"
DIR="$HOME/arch-setup"

# 1. Enable multilib repo if not enabled
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
  echo "[*] Enabling multilib repository..."
  sudo sed -i '/#\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
  sudo pacman -Syy
fi

# 2. Refresh mirror list
echo "[*] Updating mirrorlist..."
sudo pacman -Sy --noconfirm pacman-contrib
sudo rankmirrors -n 5 /etc/pacman.d/mirrorlist > /tmp/mirrorlist
sudo mv /tmp/mirrorlist /etc/pacman.d/mirrorlist
sudo pacman -Syyu --noconfirm

# 3. Clone repo if not already cloned
if [ ! -d "$DIR/.git" ]; then
    echo "[*] Cloning setup repo..."
    if git ls-remote "${REPO_SSH}" &>/dev/null; then
        git clone "${REPO_SSH}" "$DIR"
    else
        echo "[*] SSH failed, falling back to HTTPS..."
        git clone "${REPO_HTTPS}" "$DIR"
    fi
else
    echo "[*] Repo already exists at $DIR"
    cd "$DIR"

    if git diff --quiet && git diff --cached --quiet; then
      echo "[*] No local changes, pulling latest changes..."
      git pull --rebase
    else
      echo "[*] Local changes detected, stashing before pull..."
      git stash push -u -m "autostash-before-rebase"
      git pull --rebase
      echo "[*] Applying stashed changes back..."
      git stash pop || echo "[!] Conflicts may have occurred during stash pop."
    fi
fi

cd "$DIR"

mkdir -p "$DIR/packages" "$DIR/dotfiles"

# 4. Install yay-bin if not installed
if ! command -v yay &>/dev/null; then
  echo "[*] Installing yay-bin..."
  sudo pacman -S --needed --noconfirm git base-devel
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
  cd "$tmpdir/yay-bin"
  makepkg -si --noconfirm
  cd -
  rm -rf "$tmpdir"
fi

# 5. Install all packages from list
if [ -f "packages/list" ]; then
  echo "[*] Installing packages from packages/list..."
  yay -S --needed --noconfirm - < packages/list
fi

# 6. Stow dotfiles
if [ -d "dotfiles" ]; then
  echo "[*] Stowing dotfiles..."
  cd dotfiles

  for dir in */; do
    if [ -d "$dir" ]; then
      echo "   -> Stowing $dir"
      stow --target="$HOME" --restow "$dir"
    fi
  done

  cd ..
fi

echo "[✓] Bootstrap complete!"
