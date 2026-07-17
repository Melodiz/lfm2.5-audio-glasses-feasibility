# Android LFM memory attribution

Created: 2026-07-17T05:23:07.640959+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1666.9 | 1666.2 | 1666.2 | 1664.0 |
| active_peak | 1723.5 | 1722.8 | 1722.8 | 1720.6 |
| after | 1723.4 | 1722.8 | 1722.8 | 1720.5 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1015.6 | 1015.6 |
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

- Mode: `asr`.
- Input: `question.wav`.
- First text: 290.9 ms.
- First audio: not applicable.
- Total: 496.5 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
