# Third-party notices

The Android application code and UI in this directory are part of this
feasibility repository. The packaged native ARM64 runner libraries are derived
without source modification from the official archive:

- Repository: `LiquidAI/LFM2.5-Audio-1.5B-GGUF`
- Revision: `7d525f883a077e20afb782f2ff618edcae0e39e4`
- Archive: `runners/llama-liquid-audio-android-arm64.zip`

`llama-liquid-audio-server` is packaged under the Android-compatible filename
`liblfmserver.so` so Android extracts it with the other native libraries. Its
contents are unchanged; `runner-files.sha256` records the packaged hashes.

The upstream runner and dependency license texts are under
`third_party/llama-liquid-audio/`. The LFM model license is copied to
`third_party/LFM_OPEN_LICENSE.txt`. Model weights are not committed to this
repository and must be downloaded separately after reviewing that license.
