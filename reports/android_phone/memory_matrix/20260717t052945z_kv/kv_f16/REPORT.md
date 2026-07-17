# Android LFM memory attribution

Created: 2026-07-17T05:29:54.126129+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1106.9 | 1106.6 | 1106.6 | 1104.0 |
| active_peak | 1274.4 | 1273.8 | 1273.8 | 1271.5 |
| after | 1257.4 | 1256.8 | 1273.8 | 1254.4 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 556.9 | 556.9 |
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
- Input: `asr.wav`.
- First text: 2886.9 ms.
- First audio: not applicable.
- Total: 4157.5 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
