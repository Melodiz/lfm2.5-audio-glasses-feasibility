# Android LFM memory attribution

Created: 2026-07-17T05:24:16.995179+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1666.9 | 1666.3 | 1666.3 | 1664.1 |
| active_peak | 1847.9 | 1847.1 | 1847.1 | 1845.0 |
| after | 1833.6 | 1833.0 | 1847.1 | 1830.6 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1139.9 | 1139.9 |
| gguf_weights | 697.6 | 697.6 |
| shared_libraries | 9.2 | 7.5 |
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
- First text: 892.7 ms.
- First audio: not applicable.
- Total: 1631.2 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
