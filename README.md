# LFM2.5-Audio on AI Glasses — feasibility experiments

These experiments measured local Q4 behavior on Apple M2, full-model BF16 behavior on NVIDIA L4, and fixed-shape component placement, latency, memory, and numerics through Qualcomm AI Hub. All tested neural partitions placed on QCS8550 (Proxy), but the FP16 detokenizer failed numerically; continue LFM as a gated research baseline, not a glasses-ready result. QCS8550 (Proxy) is not AR1, and its figures are not AR1 performance.

## Native Android phone-only demo

The repository now includes the complete native Android deployment used on the
Nubia NX809J: application source, embedded UI, official ARM64 runner libraries,
a prebuilt debug APK, pinned model download and installation scripts, profiling
code, and measured results.

Start with [the Android deployment guide](docs/ANDROID_DEPLOYMENT.md). The
prebuilt artifact is
`android-app/releases/lfm-audio-demo-0.1.0-debug.apk`; its SHA-256 is recorded
beside it. Model weights are downloaded separately from the pinned official
Liquid AI repository because they total roughly 1 GiB and exceed normal GitHub
file limits.

This demo is fully phone-only after installation, but it uses the official Q4
CPU backend. It is not a QNN, Hexagon NPU, AR1, or glasses measurement.

The latest [phone memory-gate experiment](reports/android_phone/experiment_batch_20260717/REPORT.md)
positively identifies HTP v81 on the Nubia and attributes the CPU runner's
memory. Disabling CPU weight repacking preserves the matched ASR diagnostic
quality, but peaks at 1365 MiB `VmHWM`. The gate is model-process peak <= 1331
MiB (1.3 GiB); the stricter decimal reading 1.3 GB = 1240 MiB is noted for
reference. Configurations below the GiB threshold exceed the allowed
competing-speech WER delta. The joint memory/quality gate is therefore not yet
passed.

## Setup

Python 3.13 was used locally; the project requires Python 3.12 or newer. Install with `python -m pip install -e ".[aihub,colab]"`, omitting extras you do not need.
The virtual environment and model weights stay outside this repository at `work/venvs/lfm` and `work/cache/huggingface`.

## Layout

`scripts/` — all entry points, kept flat; see the table below.
`reports/` — measured outputs, with one file or subdirectory per experiment.
`vendor/` — pinned upstream `liquid-audio`, unmodified.
`output/` — the technical report PDF.
`workstreams/` — local quality-evaluation output; the default for `scripts/evaluate_quality_locally.py`.
`android-app/` — native Android source, ARM64 runtime libraries, and prebuilt APK.
`docs/ANDROID_DEPLOYMENT.md` — reproducible download, install, build, and profiling guide.

Archived JSON evidence had absolute local paths redacted post-capture; measured values are unchanged.

## What produced what

| Report section | Script | Output artifact |
|---|---|---|
| Qualcomm proxy component results (capture/export) | `capture_encoder_golden.py`; `export_encoder_fixed.py`; `capture_or_export_backbone_probes.py`; `capture_or_export_cached_decode_probes.py`; `capture_or_export_depth_probe.py`; `capture_or_export_detok_probe.py`; `component_utils.py` | `reports/fastconformer_export.json`, `reports/backbone_*_probe.json`, `reports/depth_export.json`, `reports/detok_probe.json`; deployable files remain under external `work/lfm-feasibility/` |
| Qualcomm proxy component results (profile/summarize) | `submit_encoder_aihub.py`; `submit_component_aihub.py`; `run_aihub_fastconformer_first_pass.sh`, `run_aihub_remaining_components.sh`, `run_aihub_int64_corrections.sh`, `run_aihub_detok_t8_correction.sh`, and `run_aihub_real_detok.sh` → `submit_component_aihub.py`; `summarize_aihub_results.py` | `reports/aihub_component_results.{json,md}`, `reports/fastconformer_aihub_first_pass.md`, `reports/operator_matrix.csv`, and external AI Hub run directories |
| NPU port (HTP v81) — not yet reflected in the PDF report | `list_aihub_devices.py`; `submit_encoder_aihub.py`; `submit_component_aihub.py`; `run_v81_aihub_batch.py`; `capture_depth_calibration.py` | `reports/android_phone/npu/qairt_v81_support.md`, `reports/android_phone/npu/v81_fp16_transfer/REPORT.md`, `reports/android_phone/npu/w8a16_smoke/REPORT.md` |
| What was measured | `run_colab_bf16_golden.sh` → `colab_lfm_bf16_launcher.py` → `colab_lfm_bf16_runner.py`; `run_colab_smoke.sh` → `colab_smoke.py`; `run_colab_auth_refresh.sh`; `run_colab_auth_smoke_bf16_pipeline.sh`; `run_golden_asr.py` | `reports/colab_bf16/`, `reports/colab_bf16_report.md`, and downloaded external Colab artifacts |
| Quality findings (ASR and generated-audio diagnostics) | `run_colab_candidate_quality.sh` → `colab_candidate_quality_launcher.py` → `colab_candidate_quality_runner.py`; `evaluate_quality_locally.py`; `evaluate_moonshine_local.py`; `prepare_real_detok_probes.py`; `analyze_detok_waveform_error.py` | `reports/colab_candidate_quality/`, `reports/moonshine_quality/`, `reports/detok_real_turn1_t8/`, `reports/detok_waveform_t4/`, `reports/detok_waveform_t8/`; local audit output defaults to `workstreams/quality_eval/` |
| Memory and context | `build_memory_ledger.py` | `reports/memory/memory_ledger.{csv,json}` |
| Local Q4 inference-technique matrix | `run_local_q4_matrix.sh`; `summarize_local_q4_matrix.py` | `reports/local_q4_matrix/` |
| Additional Qualcomm speech profiles | `summarize_qai_comparators.py` | `reports/comparators/qai_comparator_matrix.{csv,json}` |
| Reproducibility | `check_environment.py`; `run_aihub_device_discovery.sh` → `list_aihub_devices.py`; `validate_local_exports.py` | environment/device output and `reports/local_export_validation.json` |
| Native Android deployment | `download_lfm_q4_models.sh`; `install_native_phone_demo.sh`; `build_android_apk.sh`; `refresh_android_runner.sh`; `profile_native_android_app.py`; `probe_native_android_cpu.py`; `profile_android_memory_attribution.py`; `run_android_memory_matrix.py`; `prepare_phone_asr_diagnostic.py`; `run_phone_asr_diagnostic.py` | `android-app/releases/`, `reports/android_phone/native_profile/`, `reports/android_phone/experiment_batch_20260717/` |
| Public report assembly | `build_public_report.py`; `build_public_data_bundle.py` | `reports/public/`, `reports/public/data/`, `output/pdf/LFM2.5_Audio_Glasses_Feasibility_Report.pdf` |

## Reproducing

1. Install the environment and run `scripts/check_environment.py`.
2. Capture and export the fixed components, submit the AI Hub runners, then summarize the Qualcomm proxy component results.
3. Run the Colab BF16/quality workflows, the local Q4 matrix, and comparator summarization.
4. Build the memory ledger, public report, and public data bundle last.
5. For the native phone baseline, follow `docs/ANDROID_DEPLOYMENT.md`; it pins
   the exact Q4 model and Android runner revision used in the published profile.

## Limitations

No exact AR1 target, end-to-end glasses pipeline, host/NPU transfer budget, or target-device power result was measured. The native Android result is CPU Q4 on a Nubia phone, not NPU execution.
See the report's Limitations section for the complete release boundaries and interpretation rules.

## License

Code written for this repository is Apache-2.0; `vendor/`, packaged native binaries, and model weights have separate terms. Android third-party notices are under `android-app/third_party/`, and LFM Open License v1.0 includes a commercial revenue threshold.
