# Android LFM memory attribution

Created: 2026-07-17T05:26:27.153091+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1646.4 | 1645.7 | 1645.7 | 1643.4 |
| active_peak | 1827.4 | 1826.7 | 1826.7 | 1824.4 |
| after | 1813.0 | 1812.5 | 1826.7 | 1810.0 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| anonymous | 1119.2 | 1119.2 |
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
- Input: `asr.wav`.
- First text: 903.4 ms.
- First audio: not applicable.
- Total: 1635.3 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
