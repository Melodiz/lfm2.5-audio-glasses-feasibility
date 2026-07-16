#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE="$(cd "$PROJECT_DIR/../.." && pwd)"
PYTHON="$WORKSPACE/work/venvs/aihub/bin/python"
RUNNER="$SCRIPT_DIR/submit_component_aihub.py"
MODEL="$WORKSPACE/work/lfm-feasibility/exports/fastconformer_adapter_mel80.pt2"
IO="$WORKSPACE/work/lfm-feasibility/exports/fastconformer_adapter_mel80.npz"
DEVICE="QCS8550 (Proxy)"
DEVICE_OS="12"
STAMP="$(date -u +%Y%m%dT%H%M%SZ | tr '[:upper:]' '[:lower:]')"
OUTPUT_DIR="$WORKSPACE/work/lfm-feasibility/aihub/fastconformer-first-pass-$STAMP"
LOG="$OUTPUT_DIR/run.log"

mkdir -p "$OUTPUT_DIR"
exec >"$LOG" 2>&1

run_one() {
  local runtime="$1"
  "$PYTHON" "$RUNNER" \
    --component fastconformer \
    --device "$DEVICE" \
    --device-os "$DEVICE_OS" \
    --device-attribute framework:qnn \
    --model "$MODEL" \
    --io "$IO" \
    --input mel \
    --output '#0=adapted' \
    --runtime "$runtime" \
    --output-dir "$OUTPUT_DIR"
}

set +e
run_one strict-npu
STRICT_RC=$?
run_one ort-diagnostic
DIAGNOSTIC_RC=$?
set -e

python3 - "$OUTPUT_DIR/status.json" "$STRICT_RC" "$DIAGNOSTIC_RC" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
payload = {
    "strict_npu_returncode": int(sys.argv[2]),
    "ort_diagnostic_returncode": int(sys.argv[3]),
}
payload["status"] = "passed" if not any(payload.values()) else "failed_or_partial"
path.write_text(json.dumps(payload, indent=2) + "\n")
print(json.dumps(payload, indent=2))
PY

if [[ "$STRICT_RC" -ne 0 || "$DIAGNOSTIC_RC" -ne 0 ]]; then
  exit 2
fi
