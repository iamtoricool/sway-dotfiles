# FVM
export PATH="$HOME/fvm/bin:$PATH"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# Add Flutter SDK Path
export PATH="$PATH":"$HOME/fvm/default/bin"

# Add Dart executables to path
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Add Chrome Executable Variable
export CHROME_EXECUTABLE="$(which brave)"

# Export Dart Environment Path
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Export Shorebird Path
export PATH="$PATH":"$HOME/.shorebird/bin"
