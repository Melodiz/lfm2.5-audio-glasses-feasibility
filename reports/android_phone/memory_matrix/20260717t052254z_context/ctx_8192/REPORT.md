# Android LFM memory attribution

Created: 2026-07-17T05:23:16.723177+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1739.8 | 1739.2 | 1739.2 | 1736.9 |
| active_peak | 1795.2 | 1795.0 | 1795.0 | 1792.4 |
| after | 1795.2 | 1795.0 | 1795.0 | 1792.3 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1087.1 | 1087.1 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.3 | 7.6 |
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
- Input: `question.wav`.
- First text: 278.0 ms.
- First audio: not applicable.
- Total: 492.5 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
