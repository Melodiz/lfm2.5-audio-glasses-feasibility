# LFM2.5-Audio on AI Glasses — feasibility experiments

These experiments measured local Q4 behavior on Apple M2, full-model BF16 behavior on NVIDIA L4, and fixed-shape component placement, latency, memory, and numerics through Qualcomm AI Hub. All tested neural partitions placed on QCS8550 (Proxy), but the FP16 detokenizer failed numerically; continue LFM as a gated research baseline, not a glasses-ready result. QCS8550 (Proxy) is not AR1, and its figures are not AR1 performance.

## Setup

Python 3.13 was used locally; the project requires Python 3.12 or newer. Install with `python -m pip install -e ".[aihub,colab]"`, omitting extras you do not need.
The virtual environment and model weights stay outside this repository at `work/venvs/lfm` and `work/cache/huggingface`.

## Layout

`scripts/` — all entry points, kept flat; see the table below.
`reports/` — measured outputs, with one file or subdirectory per experiment.
`vendor/` — pinned upstream `liquid-audio`, unmodified.
`output/` — the technical report PDF.
`workstreams/` — local quality-evaluation output; the default for `scripts/evaluate_quality_locally.py`.

## What produced what

| Report section | Script | Output artifact |
|---|---|---|
| §4 Qualcomm proxy components: capture/export | `capture_encoder_golden.py`; `export_encoder_fixed.py`; `capture_or_export_backbone_probes.py`; `capture_or_export_cached_decode_probes.py`; `capture_or_export_depth_probe.py`; `capture_or_export_detok_probe.py`; `component_utils.py` | `reports/fastconformer_export.json`, `reports/backbone_*_probe.json`, `reports/depth_export.json`, `reports/detok_probe.json`; deployable files remain under external `work/lfm-feasibility/` |
| §4 Qualcomm proxy components: profile/summarize | `submit_encoder_aihub.py`; `submit_component_aihub.py`; `run_aihub_fastconformer_first_pass.sh`, `run_aihub_remaining_components.sh`, `run_aihub_int64_corrections.sh`, `run_aihub_detok_t8_correction.sh`, and `run_aihub_real_detok.sh` → `submit_component_aihub.py`; `summarize_aihub_results.py` | `reports/aihub_component_results.{json,md}`, `reports/fastconformer_aihub_first_pass.md`, `reports/operator_matrix.csv`, `reports/aihub_real_detok_latest.txt`, and external AI Hub run directories |
| §5 Full-model BF16 golden | `run_colab_bf16_golden.sh` → `colab_lfm_bf16_launcher.py` → `colab_lfm_bf16_runner.py`; `run_colab_smoke.sh` → `colab_smoke.py`; `run_colab_auth_refresh.sh`; `run_colab_auth_smoke_bf16_pipeline.sh`; `run_golden_asr.py` | `reports/colab_bf16/`, `reports/colab_bf16_report.md`, and downloaded external Colab artifacts |
| §6 Quality findings and ASR diagnostic | `run_colab_candidate_quality.sh` → `colab_candidate_quality_launcher.py` → `colab_candidate_quality_runner.py`; `evaluate_quality_locally.py`; `evaluate_moonshine_local.py`; `prepare_real_detok_probes.py`; `analyze_detok_waveform_error.py` | `reports/colab_candidate_quality/`, `reports/moonshine_quality/`, `reports/detok_real_turn1_t8/`, `reports/detok_waveform_t4/`, `reports/detok_waveform_t8/`; local audit output defaults to `workstreams/quality_eval/` |
| §7 Memory ledger | `build_memory_ledger.py` | `reports/memory/memory_ledger.{csv,json}` |
| §8 Local Q4 matrix | `run_local_q4_matrix.sh`; `summarize_local_q4_matrix.py` | `reports/local_q4_matrix/` |
| §9 Qualcomm comparator profiles | `summarize_qai_comparators.py` | `reports/comparators/qai_comparator_matrix.{csv,json}` |
| §14 Reproducibility and checks | `check_environment.py`; `run_aihub_device_discovery.sh` → `list_aihub_devices.py`; `validate_local_exports.py` | environment/device output and `reports/local_export_validation.json` |
| Public report assembly | `build_public_report.py`; `build_public_data_bundle.py` | `reports/public/`, `reports/public/data/`, `output/pdf/LFM2.5_Audio_Glasses_Feasibility_Report.pdf` |

## Reproducing

1. Install the environment and run `scripts/check_environment.py`.
2. Capture and export the fixed components, submit the AI Hub runners, then summarize §4.
3. Run the Colab BF16/quality workflows, the local Q4 matrix, and comparator summarization.
4. Build the memory ledger, public report, and public data bundle last.

## Limitations

No exact AR1 target, end-to-end glasses pipeline, host/NPU transfer budget, or target-device power and thermal result was measured.
See report §13 for the complete release boundaries and interpretation rules.

## License

Code written for this repository is Apache-2.0; `vendor/` and model weights have separate terms, and LFM Open License v1.0 includes a commercial revenue threshold.
