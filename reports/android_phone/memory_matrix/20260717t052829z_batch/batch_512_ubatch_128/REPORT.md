# Android LFM memory attribution

Created: 2026-07-17T05:28:52.248210+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1091.3 | 1090.8 | 1090.8 | 1088.4 |
| active_peak | 1249.8 | 1249.0 | 1249.0 | 1246.8 |
| after | 1233.8 | 1233.2 | 1249.0 | 1230.8 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 532.3 | 532.3 |
| shared_libraries | 9.0 | 7.3 |
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
- First text: 3107.3 ms.
- First audio: not applicable.
- Total: 4297.7 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
