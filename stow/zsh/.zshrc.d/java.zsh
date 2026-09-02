# Set up Java (sdkman) environment variables.
# This file is sourced from .zprofile, so the variables also reach
# GUI apps launched by the login session (sway -> VSCodium, etc.).
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
if [ -x "$JAVA_HOME/bin/java" ]; then
    export PATH="$JAVA_HOME/bin:$PATH"
fi