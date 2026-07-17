# Android LFM memory attribution

Created: 2026-07-17T05:27:17.204976+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1646.1 | 1645.4 | 1645.4 | 1643.3 |
| active_peak | 1705.8 | 1705.1 | 1705.1 | 1702.9 |
| after | 0.0 | 0.0 | 0.0 | 0.0 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 997.9 | 997.9 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.0 | 7.3 |
| other_file_backed | 0.9 | 0.1 |
| device_mappings | 0.3 | 0.0 |
| special_mappings | 0.0 | 0.0 |

## Per-GGUF active residency

| File | RSS MiB | PSS MiB |
|---|---:|---:|
| `LFM2.5-Audio-1.5B-Q4_0.gguf` | 652.3 | 652.3 |
| `tokenizer-LFM2.5-Audio-1.5B-Q4_0.gguf` | 45.4 | 45.4 |

## Request

- Mode: `chat`.
- Input: `question.wav`.
- First text: 264.0 ms.
- First audio: 338.6 ms.
- Total: 3188.0 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
