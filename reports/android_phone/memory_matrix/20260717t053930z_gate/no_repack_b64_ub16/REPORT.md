# Android LFM memory attribution

Created: 2026-07-17T05:40:10.051224+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1081.3 | 1080.7 | 1080.7 | 1078.5 |
| active_peak | 1303.6 | 1302.8 | 1302.8 | 1300.8 |
| after | 1287.9 | 1287.3 | 1303.3 | 1285.0 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 586.0 | 586.0 |
| shared_libraries | 9.3 | 7.6 |
| other_file_backed | 0.9 | 0.1 |
| device_mappings | 0.3 | 0.0 |
| special_mappings | 0.0 | 0.0 |

## Per-GGUF active residency

| File | RSS MiB | PSS MiB |
|---|---:|---:|
| `LFM2.5-Audio-1.5B-Q4_0.gguf` | 661.2 | 661.2 |
| `tokenizer-LFM2.5-Audio-1.5B-Q4_0.gguf` | 45.9 | 45.9 |

## Request

- Mode: `asr`.
- Input: `sample_04.wav`.
- First text: 6399.4 ms.
- First audio: not applicable.
- Total: 9524.2 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
