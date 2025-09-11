#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/yukioe/arch.git"
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

# 3. Clone your repo if not exists
if [ ! -d "$DIR" ]; then
  git clone "$REPO" "$DIR"
fi

cd "$DIR"

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
    stow --target="$HOME" "$dir"
  done
fi

echo "[✓] Bootstrap complete!"
