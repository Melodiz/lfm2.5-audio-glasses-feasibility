# Android LFM memory attribution

Created: 2026-07-17T05:28:36.004002+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1107.1 | 1106.5 | 1106.5 | 1104.2 |
| active_peak | 1280.0 | 1278.9 | 1278.9 | 1277.0 |
| after | 1265.6 | 1264.5 | 1278.9 | 1262.6 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 562.3 | 562.3 |
| shared_libraries | 9.3 | 7.5 |
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
- First text: 1664.8 ms.
- First audio: not applicable.
- Total: 2491.7 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
