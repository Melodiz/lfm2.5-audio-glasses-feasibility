# Android LFM memory attribution

Created: 2026-07-17T05:30:02.365579+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1105.4 | 1104.8 | 1104.8 | 1102.5 |
| active_peak | 1277.0 | 1276.1 | 1276.1 | 1274.1 |
| after | 1259.9 | 1259.2 | 1276.1 | 1257.0 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 559.3 | 559.3 |
| shared_libraries | 9.2 | 7.5 |
| other_file_backed | 0.9 | 0.1 |
| device_mappings | 0.3 | 0.0 |
| special_mappings | 0.0 | 0.0 |

## Per-GGUF active residency

| File | RSS MiB | PSS MiB |
|---|---:|---:|
| `LFM2.5-Audio-1.5B-Q4_0.gguf` | 661.2 | 661.2 |
| `tokenizer-LFM2.5-Audio-1.5B-Q4_0.gguf` | 45.9 | 45.9 |

## Request

- Mode: `asr`.
- Input: `asr.wav`.
- First text: 2885.9 ms.
- First audio: not applicable.
- Total: 4137.7 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
