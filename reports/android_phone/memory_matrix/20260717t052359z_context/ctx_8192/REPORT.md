# Android LFM memory attribution

Created: 2026-07-17T05:24:29.505521+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1739.7 | 1738.8 | 1738.8 | 1736.9 |
| active_peak | 1920.9 | 1920.0 | 1920.0 | 1918.0 |
| after | 1903.8 | 1903.1 | 1920.0 | 1900.9 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1212.7 | 1212.7 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.3 | 7.6 |
| other_file_backed | 0.9 | 0.1 |
| device_mappings | 0.3 | 0.0 |
| special_mappings | 0.0 | 0.0 |

## Per-GGUF active residency

| File | RSS MiB | PSS MiB |
|---|---:|---:|
| `LFM2.5-Audio-1.5B-Q4_0.gguf` | 652.3 | 652.3 |
| `tokenizer-LFM2.5-Audio-1.5B-Q4_0.gguf` | 45.4 | 45.4 |

## Request

- Mode: `asr`.
- Input: `asr.wav`.
- First text: 1575.9 ms.
- First audio: not applicable.
- Total: 2579.2 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
