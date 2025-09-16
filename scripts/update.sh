#!/usr/bin/env bash
set -e

DIR="$HOME/arch-setup"

cd "$DIR"

# update package list (yay covers repo + AUR)
yay -Qqe > packages/list

git pull --rebase

# commit changes with custom message
MSG="${1:-Update packages & dotfiles on $(hostname)}"
git add packages/list dotfiles/
git commit -m "$MSG"
git push

echo "[✓] Update pushed with message: $MSG"
