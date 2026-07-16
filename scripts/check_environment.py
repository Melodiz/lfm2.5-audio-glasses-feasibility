#!/usr/bin/env python3
from __future__ import annotations

import json
import platform
import sys
from pathlib import Path

import torch
import torchaudio
import transformers
from accelerate import __version__ as accelerate_version


def main() -> None:
    workspace = Path(__file__).resolve().parents[3]
    result = {
        "python": sys.version,
        "platform": platform.platform(),
        "machine": platform.machine(),
        "torch": torch.__version__,
        "torchaudio": torchaudio.__version__,
        "transformers": transformers.__version__,
        "accelerate": accelerate_version,
        "mps_built": torch.backends.mps.is_built(),
        "mps_available": torch.backends.mps.is_available(),
        "workspace": str(workspace),
        "vendor_repo_present": (workspace / "work/vendor/liquid-audio").is_dir(),
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()

