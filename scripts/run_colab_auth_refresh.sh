#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COLAB_BUNDLE="$PROJECT_DIR/colab-cli-skill"

export COLAB_PYTHON="${COLAB_PYTHON:-/opt/homebrew/bin/python3.13}"
set -a
source "$COLAB_BUNDLE/.colab_env"
set +a

# Seed the private home once. The OAuth flow then replaces token.json with the
# refreshed token. Subsequent smoke/full-run wrappers deliberately preserve it.
colab_env_materialize
colab_env_bootstrap_cli

OFFICIAL_OAUTH_CONFIG="$COLAB_VENV/lib/python3.13/site-packages/colab_cli/oauth_config.json"
if [[ ! -f "$OFFICIAL_OAUTH_CONFIG" ]]; then
  printf 'Official Colab OAuth config not found: %s\n' "$OFFICIAL_OAUTH_CONFIG" >&2
  exit 2
fi

HOME="$COLAB_HOME" "$COLAB_CLI" \
  --client-oauth-config "$OFFICIAL_OAUTH_CONFIG" \
  --auth "$COLAB_AUTH" sessions
