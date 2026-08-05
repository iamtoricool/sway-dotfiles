# dotfiles

Personal Linux dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/) and shared for reuse.

The repository is organized so every package under [`stow/`](stow/) mirrors the layout of your home
directory. Installing a package symlinks its files into `$HOME`, so configs stay versioned in one
place while apps read them from their standard locations.

## Requirements

- GNU stow (`sudo apt install stow` or equivalent)
- Per-package runtime deps (see table below)

## Quick start

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

./install.sh            # install all packages into $HOME
./install.sh sway       # install only sway
./install.sh --list     # show packages
./install.sh --remove   # unlink everything
./install.sh --adopt    # pull your existing ~/.config files into the repo, then install
```

## Packages

| Package    | Installs                                 | Notes / dependencies                     |
|------------|------------------------------------------|------------------------------------------|
| `sway`     | `~/.config/sway/`                        | Sway compositor config + modules; needs `jq`, `grim`, `slurp`, `satty`, `swaylock`, `rofi`, `alacritty`, `pactl`, `brightnessctl` |
| `waybar`   | `~/.config/waybar/`                      | Status bar; includes `mediaplayer.py` (needs `playerctl`) |
| `rofi`     | `~/.config/rofi/dracula.rasi`            | Dracula launcher theme                   |
| `opencode` | `~/.config/opencode/opencode.jsonc`      | opencode config + Figma MCP server (`bunx cursor-talk-to-figma-mcp`) |
| `xdg`      | `~/.config/xdg-desktop-portal/config`    | Secret portal → `keepassxc`              |
| `zsh`      | `~/.zshrc`, `~/.zprofile`, `~/.zshrc.d/` | Oh My Zsh; `.zprofile` sources every `~/.zshrc.d/*.zsh` |

## Structure

```
dotfiles/
├── install.sh              # stow wrapper (install / remove / adopt / list)
├── stow/
│   ├── sway/.config/sway/  # config + modules (keybinds, window_rules, scripts)
│   ├── waybar/.config/waybar/
│   ├── rofi/.config/rofi/
│   ├── opencode/.config/opencode/
│   ├── xdg/.config/xdg-desktop-portal/
│   └── zsh/                # .zshrc, .zprofile, .zshrc.d/*.zsh
└── README.md
```

## Customization

- **Machine-specific settings** are marked with comments and kept in the shared package for
  simplicity. For example, `stow/sway/.config/sway/modules/monitor_output` is your monitor's
  resolution/refresh — edit it, or run `swaymsg -t get_outputs` and adapt.
- **PATH / dev-tooling** lives in `~/.zshrc.d/` as drop-in `.zsh` files (`rust.zsh`,
  `android_sdk.zsh`, `flutter.zsh`, `web_dev.zsh`). Add your own, or delete the ones you don't use.
- **Waybar media module** reads `~/.config/waybar/mediaplayer.py`; filter to a specific player with
  `--player spotify` in `config.jsonc`.

## Reusing / forking

1. Fork the repo and change the remote.
2. Edit `stow/sway/.config/sway/modules/monitor_output` for your display.
3. Trim `~/.zshrc.d/` files you don't need.
4. Adjust sway keybinds / waybar modules to taste.

## Tips

- `stow` only symlinks; it never copies. Keep the repo somewhere permanent (e.g. `~/dotfiles`).
- After editing, re-run `./install.sh --adopt` if a package conflicts with an existing config.
