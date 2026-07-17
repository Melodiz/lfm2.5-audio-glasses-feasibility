# Android LFM memory attribution

Created: 2026-07-17T05:39:56.065563+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1081.6 | 1080.8 | 1080.8 | 1078.7 |
| active_peak | 1305.9 | 1305.0 | 1305.0 | 1303.1 |
| after | 1290.6 | 1289.8 | 1305.9 | 1287.7 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 588.5 | 588.5 |
| shared_libraries | 9.0 | 7.3 |
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
- Input: `sample_04.wav`.
- First text: 6002.9 ms.
- First audio: not applicable.
- Total: 8798.5 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
