#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APP_DIR="$REPO_ROOT/android-app"

if [[ -z "${JAVA_HOME:-}" ]] && [[ -x /usr/libexec/java_home ]]; then
  export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
fi
if [[ -z "${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}" ]]; then
  echo "Set ANDROID_HOME or ANDROID_SDK_ROOT to an Android SDK containing API 35." >&2
  exit 2
fi

"$APP_DIR/gradlew" -p "$APP_DIR" :app:assembleDebug
echo "APK: $APP_DIR/app/build/outputs/apk/debug/app-debug.apk"
