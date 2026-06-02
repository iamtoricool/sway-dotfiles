#!/usr/bin/env bash
set -euo pipefail

echo "=== Flutter Dev Container Init ==="

export DEBIAN_FRONTEND=noninteractive

# ---- JDK ----
echo "[1/5] Installing Eclipse Temurin JDK 21..."
wget -qO /usr/share/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public
echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/VERSION_CODENAME/{print$2}' /etc/os-release) main" \
  > /etc/apt/sources.list.d/adoptium.list
apt-get update -qq
apt-get install -y temurin-21-jdk

# ---- FVM + Flutter ----
echo "[2/5] Installing FVM..."
export FVM_CACHE_PATH="/opt/dev/fvm-cache"
mkdir -p /opt/dev/fvm/bin /opt/dev/fvm-cache
curl -fsSL "https://github.com/leoafarias/fvm/releases/download/4.1.0/fvm-4.1.0-linux-x64.tar.gz" \
  | tar -xz -C /tmp/
mv /tmp/fvm/fvm /opt/dev/fvm/bin/
chmod +x /opt/dev/fvm/bin/fvm
rm -rf /tmp/fvm
export PATH="/opt/dev/fvm/bin:$PATH"

echo "Installing Flutter stable via FVM..."
fvm config --cache-path "$FVM_CACHE_PATH"
fvm install stable
fvm global stable

# ---- Android SDK ----
echo "[3/5] Installing Android SDK..."
export ANDROID_HOME="/opt/dev/android-sdk"
export ANDROID_SDK_ROOT="/opt/dev/android-sdk"
export ANDROID_AVD_HOME="/opt/dev/android-avd"
mkdir -p "$ANDROID_HOME" "$ANDROID_AVD_HOME"

CMDLINE_TOOLS_ZIP="commandlinetools-linux-14742923_latest.zip"
curl -fsSL "https://dl.google.com/android/repository/$CMDLINE_TOOLS_ZIP" -o /tmp/cmdline-tools.zip
unzip -q /tmp/cmdline-tools.zip -d /tmp/cmdline-tools-extracted
mkdir -p "$ANDROID_HOME/cmdline-tools"
mv /tmp/cmdline-tools-extracted/cmdline-tools "$ANDROID_HOME/cmdline-tools/latest"
rm -rf /tmp/cmdline-tools.zip /tmp/cmdline-tools-extracted

export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
yes | sdkmanager --licenses 2>/dev/null || true
sdkmanager \
  "platform-tools" \
  "platforms;android-34" \
  "platforms;android-35" \
  "platforms;android-36" \
  "build-tools;35.0.0" \
  "build-tools;36.0.0" \
  "emulator" \
  "system-images;android-34;google_apis;x86_64" \
  2>/dev/null || true

# ---- Dart pub cache ----
echo "[4/5] Setting up Dart pub cache..."
mkdir -p /opt/dev/pub-cache

# ---- Environment profile ----
echo "[5/5] Writing environment profile..."
cat > /etc/profile.d/flutter-env.sh << 'ENVEOF'
export CONTAINER_ID="flutter-dev"
export FVM_CACHE_PATH="/opt/dev/fvm-cache"
export FVM_DIR="/opt/dev/fvm"
export ANDROID_HOME="/opt/dev/android-sdk"
export ANDROID_SDK_ROOT="/opt/dev/android-sdk"
export ANDROID_AVD_HOME="/opt/dev/android-avd"
export PUB_CACHE="/opt/dev/pub-cache"
export CHROME_EXECUTABLE="$(command -v chromium-browser 2>/dev/null || true)"

export PATH="/opt/dev/fvm/bin:$PATH"
export PATH="/opt/dev/fvm-cache/default/bin:$PATH"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/build-tools/35.0.0"
export PATH="$PATH:/opt/dev/pub-cache/bin"
ENVEOF

chmod +x /etc/profile.d/flutter-env.sh

chown -R "$(stat -c '%u:%g' "$(ls -d /home/* | head -1)")" /opt/dev/ 2>/dev/null

echo "=== Done! ==="
echo "Restart your shell or run: source /etc/profile.d/flutter-env.sh"
