# Android LFM memory attribution

Created: 2026-07-17T05:22:58.533629+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1646.3 | 1645.1 | 1645.1 | 1643.4 |
| active_peak | 1702.1 | 1701.0 | 1701.0 | 1699.3 |
| after | 1702.1 | 1701.0 | 1701.0 | 1699.2 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 994.1 | 994.1 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.1 | 7.4 |
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
- Input: `question.wav`.
- First text: 271.7 ms.
- First audio: not applicable.
- Total: 482.9 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
