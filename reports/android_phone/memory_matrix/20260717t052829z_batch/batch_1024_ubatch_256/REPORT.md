# Android LFM memory attribution

Created: 2026-07-17T05:28:43.958587+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1105.3 | 1104.5 | 1104.5 | 1102.3 |
| active_peak | 1268.0 | 1267.0 | 1267.0 | 1265.0 |
| after | 1251.0 | 1250.1 | 1267.0 | 1247.9 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 550.6 | 550.6 |
| shared_libraries | 9.0 | 7.2 |
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
- Input: `asr.wav`.
- First text: 2771.6 ms.
- First audio: not applicable.
- Total: 3971.6 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
