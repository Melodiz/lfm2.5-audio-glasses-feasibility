# Android LFM memory attribution

Created: 2026-07-17T05:40:22.933434+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1077.7 | 1077.0 | 1077.0 | 1074.8 |
| active_peak | 1301.9 | 1301.0 | 1301.0 | 1299.0 |
| after | 1286.2 | 1285.5 | 1301.4 | 1283.3 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 584.3 | 584.3 |
| shared_libraries | 9.1 | 7.4 |
| other_file_backed | 1.0 | 0.1 |
| device_mappings | 0.3 | 0.0 |
| special_mappings | 0.0 | 0.0 |

## Per-GGUF active residency

| File | RSS MiB | PSS MiB |
|---|---:|---:|
| `LFM2.5-Audio-1.5B-Q4_0.gguf` | 661.2 | 661.2 |
| `tokenizer-LFM2.5-Audio-1.5B-Q4_0.gguf` | 45.9 | 45.9 |

## Request

- Mode: `asr`.
- Input: `sample_04.wav`.
- First text: 6215.3 ms.
- First audio: not applicable.
- Total: 8862.3 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
