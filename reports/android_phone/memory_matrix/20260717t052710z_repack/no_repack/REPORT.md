# Android LFM memory attribution

Created: 2026-07-17T05:27:26.626872+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1106.9 | 1106.5 | 1106.5 | 1104.1 |
| active_peak | 1163.0 | 1162.1 | 1162.5 | 1160.1 |
| after | 0.0 | 0.0 | 0.0 | 0.0 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 445.4 | 445.4 |
| shared_libraries | 9.2 | 7.5 |
| other_file_backed | 0.9 | 0.1 |
| device_mappings | 0.3 | 0.0 |
| special_mappings | 0.0 | 0.0 |

## Per-GGUF active residency

| File | RSS MiB | PSS MiB |
|---|---:|---:|
| `LFM2.5-Audio-1.5B-Q4_0.gguf` | 661.2 | 661.2 |
| `tokenizer-LFM2.5-Audio-1.5B-Q4_0.gguf` | 45.9 | 45.9 |

## Request

- Mode: `chat`.
- Input: `question.wav`.
- First text: 1036.4 ms.
- First audio: 1217.7 ms.
- Total: 5589.5 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
