# User-local binaries (installed via cargo, pipx, etc.)
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/home/elliot/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
