# Android LFM memory attribution

Created: 2026-07-17T05:29:00.547729+00:00

All values are KiB-derived MiB from `/proc/<pid>/smaps`. The active capture is the highest-RSS sample observed while one request was executing.

| Capture | smaps RSS | VmRSS | VmHWM | PSS |
|---|---:|---:|---:|---:|
| idle | 1085.2 | 1084.5 | 1084.5 | 1082.4 |
| active_peak | 1240.2 | 1239.1 | 1239.1 | 1237.3 |
| after | 1223.7 | 1222.7 | 1239.1 | 1220.7 |

## Active-peak attribution

| Category | RSS MiB | PSS MiB |
|---|---:|---:|
| gguf_weights | 707.2 | 707.2 |
| anonymous | 522.7 | 522.7 |
| shared_libraries | 9.1 | 7.3 |
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
- Input: `asr.wav`.
- First text: 3058.1 ms.
- First audio: not applicable.
- Total: 4286.9 ms.

The raw peak smaps file has app-private installation paths normalized. `mapping_groups.csv` contains every grouped mapping for independent checking.
