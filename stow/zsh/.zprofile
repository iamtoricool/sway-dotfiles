for rc_file in "$HOME/.zshrc.d/"*.zsh; do
  [ -f "$rc_file" ] && source "$rc_file"
done
