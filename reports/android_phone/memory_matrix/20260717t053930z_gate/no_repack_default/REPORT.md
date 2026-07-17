# Android LFM memory attribution

Created: 2026-07-17T05:39:42.962280+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1108.7 | 1108.5 | 1108.5 | 1105.9 |
| active_peak | 1348.7 | 1347.9 | 1347.9 | 1345.9 |
| after | 1344.9 | 1344.3 | 1347.9 | 1342.1 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 631.3 | 631.3 |
| shared_libraries | 9.0 | 7.4 |
| other_file_backed | 0.9 | 0.0 |
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
- First text: 5261.7 ms.
- First audio: not applicable.
- Total: 7872.7 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
