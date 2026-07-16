#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE="$(cd "$PROJECT_DIR/../.." && pwd)"
STAMP="$(date -u +%Y%m%dT%H%M%SZ | tr '[:upper:]' '[:lower:]')"
OUTPUT_DIR="$WORKSPACE/work/lfm-feasibility/aihub/detok-t8-correction-$STAMP"
mkdir -p "$OUTPUT_DIR"
exec >"$OUTPUT_DIR/run.log" 2>&1

"$WORKSPACE/work/venvs/aihub/bin/python" "$SCRIPT_DIR/submit_component_aihub.py" \
  --component detokenizer-t8 \
  --device "QCS8550 (Proxy)" --device-os 12 --device-attribute framework:qnn \
  --model "$WORKSPACE/work/lfm-feasibility/exports/detok_neural_probe_codes_t8.pt2" \
  --io "$WORKSPACE/work/lfm-feasibility/exports/detok_neural_probe_codes_t8.npz" \
  --input codes --output '#0=log_abs' --output '#1=angle' \
  --runtime strict-npu --output-dir "$OUTPUT_DIR"
