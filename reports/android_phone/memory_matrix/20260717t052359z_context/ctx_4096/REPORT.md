# Android LFM memory attribution

Created: 2026-07-17T05:24:22.665363+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1690.7 | 1689.9 | 1689.9 | 1687.8 |
| active_peak | 1870.6 | 1869.9 | 1869.9 | 1867.7 |
| after | 1856.2 | 1855.7 | 1869.9 | 1853.3 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1162.8 | 1162.8 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.0 | 7.3 |
| other_file_backed | 0.9 | 0.0 |
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
- First text: 889.9 ms.
- First audio: not applicable.
- Total: 1654.3 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
