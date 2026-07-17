# Android LFM memory attribution

Created: 2026-07-17T05:25:39.992263+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1109.3 | 1108.8 | 1108.8 | 1106.4 |
| active_peak | 1164.2 | 1163.4 | 1163.4 | 1161.3 |
| after | 1164.1 | 1163.4 | 1163.4 | 1161.2 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 446.5 | 446.5 |
| shared_libraries | 9.2 | 7.5 |
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
- Input: `question.wav`.
- First text: 559.3 ms.
- First audio: not applicable.
- Total: 816.0 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
