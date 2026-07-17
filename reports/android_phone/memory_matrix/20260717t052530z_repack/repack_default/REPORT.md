# Android LFM memory attribution

Created: 2026-07-17T05:25:35.067489+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1646.4 | 1645.9 | 1645.9 | 1643.4 |
| active_peak | 1702.4 | 1701.6 | 1701.6 | 1699.4 |
| after | 1702.3 | 1701.6 | 1701.6 | 1699.3 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 994.2 | 994.2 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.3 | 7.5 |
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
- First text: 276.2 ms.
- First audio: not applicable.
- Total: 493.1 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
