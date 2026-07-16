#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import platform
import sys
import time
from pathlib import Path


WORKSPACE = Path(__file__).resolve().parents[3]
os.environ.setdefault("HF_HOME", str(WORKSPACE / "work/cache/huggingface"))
os.environ.setdefault("PYTORCH_ENABLE_MPS_FALLBACK", "1")

import psutil  # noqa: E402
import soundfile as sf  # noqa: E402
import torch  # noqa: E402

from liquid_audio import ChatState, LFM2AudioModel, LFM2AudioProcessor  # noqa: E402


MODEL_ID = "LiquidAI/LFM2.5-Audio-1.5B"
MODEL_REVISION = "c362a0625dfe45aa588dce5f0ada28a7e5707628"


def synchronize(device: str) -> None:
    if device == "mps":
        torch.mps.synchronize()


def memory_snapshot(device: str) -> dict[str, int | None]:
    process = psutil.Process()
    snapshot: dict[str, int | None] = {
        "rss_bytes": process.memory_info().rss,
        "mps_current_allocated_bytes": None,
        "mps_driver_allocated_bytes": None,
    }
    if device == "mps" and torch.backends.mps.is_available():
        synchronize(device)
        snapshot["mps_current_allocated_bytes"] = torch.mps.current_allocated_memory()
        snapshot["mps_driver_allocated_bytes"] = torch.mps.driver_allocated_memory()
    return snapshot


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--device", choices=("mps", "cpu"), default="mps")
    parser.add_argument("--max-new-tokens", type=int, default=32)
    parser.add_argument(
        "--audio",
        type=Path,
        default=WORKSPACE / "work/vendor/liquid-audio/assets/question.wav",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=WORKSPACE / "work/lfm-feasibility/artifacts/golden-asr-smoke",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.device == "mps" and not torch.backends.mps.is_available():
        raise RuntimeError(
            "MPS is unavailable. In the Codex desktop environment this command must be "
            "run with escalated execution because the command sandbox hides Metal."
        )

    args.output_dir.mkdir(parents=True, exist_ok=True)
    dtype = torch.bfloat16
    timings: dict[str, float] = {}
    memory: dict[str, dict[str, int | None]] = {"start": memory_snapshot(args.device)}

    load_started = time.perf_counter()
    processor = LFM2AudioProcessor.from_pretrained(
        MODEL_ID,
        revision=MODEL_REVISION,
        device=args.device,
    ).eval()
    model = LFM2AudioModel.from_pretrained(
        MODEL_ID,
        revision=MODEL_REVISION,
        device=args.device,
        dtype=dtype,
    ).eval()
    synchronize(args.device)
    timings["load_seconds"] = time.perf_counter() - load_started
    memory["after_load"] = memory_snapshot(args.device)

    wav_array, sampling_rate = sf.read(args.audio, dtype="float32")
    if wav_array.ndim == 2:
        wav_array = wav_array.mean(axis=1)
    wav = torch.from_numpy(wav_array).unsqueeze(0)

    prep_started = time.perf_counter()
    chat = ChatState(processor, dtype=dtype)
    chat.new_turn("system")
    chat.add_text("Perform ASR.")
    chat.end_turn()
    chat.new_turn("user")
    chat.add_audio(wav, sampling_rate)
    chat.end_turn()
    chat.new_turn("assistant")
    synchronize(args.device)
    timings["preprocess_seconds"] = time.perf_counter() - prep_started
    memory["after_preprocess"] = memory_snapshot(args.device)

    generated_tokens: list[torch.Tensor] = []
    generated_pieces: list[str] = []
    generation_started = time.perf_counter()
    with torch.inference_mode():
        for token in model.generate_sequential(**chat, max_new_tokens=args.max_new_tokens):
            if token.numel() == 1:
                cpu_token = token.detach().cpu()
                generated_tokens.append(cpu_token)
                generated_pieces.append(processor.text.decode(cpu_token))
    synchronize(args.device)
    timings["generation_seconds"] = time.perf_counter() - generation_started
    memory["after_generation"] = memory_snapshot(args.device)

    output_tokens = (
        torch.cat([token.reshape(-1) for token in generated_tokens])
        if generated_tokens
        else torch.empty((0,), dtype=torch.long)
    )
    decoded_text = "".join(generated_pieces)

    torch.save(
        {
            "text": chat.text.detach().cpu(),
            "audio_in": chat.audio_in.detach().cpu(),
            "audio_in_lens": chat.audio_in_lens.detach().cpu(),
            "audio_out": chat.audio_out.detach().cpu(),
            "modality_flag": chat.modality_flag.detach().cpu(),
        },
        args.output_dir / "inputs.pt",
    )
    torch.save(output_tokens, args.output_dir / "output_text_tokens.pt")

    summary = {
        "model_id": MODEL_ID,
        "model_revision": MODEL_REVISION,
        "audio": str(args.audio),
        "audio_seconds": len(wav_array) / sampling_rate,
        "sampling_rate": sampling_rate,
        "device": args.device,
        "dtype": str(dtype),
        "max_new_tokens": args.max_new_tokens,
        "generated_token_count": int(output_tokens.numel()),
        "decoded_text": decoded_text,
        "timings": timings,
        "memory": memory,
        "environment": {
            "python": sys.version,
            "platform": platform.platform(),
            "torch": torch.__version__,
        },
    }
    (args.output_dir / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    (args.output_dir / "decoded.txt").write_text(decoded_text + "\n")
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()

