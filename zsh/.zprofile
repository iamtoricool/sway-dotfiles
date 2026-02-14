for rc_file in "$HOME/dotfiles/dev_env/"*.rc; do
  [ -f "$rc_file" ] && source "$rc_file"
done
