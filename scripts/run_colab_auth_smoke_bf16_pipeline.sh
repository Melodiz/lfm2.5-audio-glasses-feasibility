#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf '%s\n' 'Step 1/3: Colab account authorization'
bash "$SCRIPT_DIR/run_colab_auth_refresh.sh"

printf '%s\n' 'Step 2/3: L4 smoke test'
bash "$SCRIPT_DIR/run_colab_smoke.sh"

printf '%s\n' 'Step 3/3: full pinned BF16 golden run'
bash "$SCRIPT_DIR/run_colab_bf16_golden.sh"

printf '%s\n' 'Colab auth, smoke test, and BF16 golden pipeline completed.'
