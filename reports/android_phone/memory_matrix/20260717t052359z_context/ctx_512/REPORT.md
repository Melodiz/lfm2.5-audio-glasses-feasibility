# Android LFM memory attribution

Created: 2026-07-17T05:24:05.470013+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1646.1 | 1645.6 | 1645.6 | 1643.3 |
| active_peak | 1827.3 | 1826.4 | 1826.4 | 1824.4 |
| after | 1812.9 | 1812.4 | 1826.4 | 1810.0 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1119.2 | 1119.2 |
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
- First text: 877.8 ms.
- First audio: not applicable.
- Total: 1639.0 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
