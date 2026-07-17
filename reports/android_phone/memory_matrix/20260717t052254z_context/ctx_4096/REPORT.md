# Android LFM memory attribution

Created: 2026-07-17T05:23:12.191891+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1690.8 | 1690.1 | 1690.1 | 1687.9 |
| active_peak | 1745.0 | 1744.3 | 1744.3 | 1742.1 |
| after | 1745.0 | 1744.3 | 1744.3 | 1742.1 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1037.1 | 1037.1 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.0 | 7.4 |
| other_file_backed | 1.0 | 0.1 |
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
- First text: 295.5 ms.
- First audio: not applicable.
- Total: 511.3 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
