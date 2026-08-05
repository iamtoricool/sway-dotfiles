#!/usr/bin/env bash
#
# GNU Stow installer for the dotfiles repository.
# Symlinks every package under ./stow into your home directory.
#
# Usage:
#   ./install.sh                install all packages
#   ./install.sh sway waybar    install specific packages
#   ./install.sh --adopt        install, folding existing configs into the repo
#   ./install.sh --remove       remove all packages (symlinks)
#   ./install.sh --list         show available packages
#   ./install.sh --help         show this help
#
# Dependencies: GNU stow. Install with e.g. `sudo apt install stow`.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$SCRIPT_DIR/stow"
TARGET="$HOME"

MODE="install"
ADOPT="false"
declare -a PACKAGES=()

if ! command -v stow >/dev/null 2>&1; then
  echo "ERROR: 'stow' is not installed. Install GNU stow first." >&2
  exit 1
fi

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --adopt)  MODE="install"; ADOPT="true" ;;
    --remove) MODE="remove" ;;
    --list)   MODE="list" ;;
    --help|-h)
      sed -n '2,15p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    --*)      echo "Unknown option: $arg" >&2; exit 1 ;;
    *)        PACKAGES+=("$arg") ;;
  esac
done

# Default to picking up every package (directory immediately under stow/).
if [ "${#PACKAGES[@]}" -eq 0 ]; then
  mapfile -t PACKAGES < <(find "$STOW_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
fi

# Validate requested packages exist
local_packages=()
for pkg in "${PACKAGES[@]}"; do
  if [ ! -d "$STOW_DIR/$pkg" ]; then
    echo "WARNING: no package named '$pkg' (skipping)" >&2
    continue
  fi
  local_packages+=("$pkg")
done
PACKAGES=("${local_packages[@]}")

if [ "${#PACKAGES[@]}" -eq 0 ]; then
  echo "No packages to process." >&2
  exit 0
fi

case "$MODE" in
  list)
    echo "Available packages:"
    printf '  %s\n' "${PACKAGES[@]}"
    echo
    echo "Run './install.sh <package>...' to install, or './install.sh' for all."
    ;;
  remove)
    echo "Removing: ${PACKAGES[*]}"
    stow -v -d "$STOW_DIR" -t "$TARGET" -D "${PACKAGES[@]}"
    ;;
  install)
    echo "Installing: ${PACKAGES[*]}"
    if [ "$ADOPT" = "true" ]; then
      stow -v -d "$STOW_DIR" -t "$TARGET" --adopt "${PACKAGES[@]}"
    else
      stow -v -d "$STOW_DIR" -t "$TARGET" "${PACKAGES[@]}"
    fi
    echo "Done. Restart your shell / sway to pick up changes."
    ;;
esac