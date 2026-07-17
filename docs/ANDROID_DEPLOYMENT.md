# Native Android deployment and profiling

This directory documents the reproducible phone-only LFM2.5-Audio baseline.
The tested APK runs the official Android ARM64 Q4 CPU runner inside an Android
foreground service. It is not a Qualcomm QNN or Hexagon NPU implementation.

## Tested configuration

- Phone: Nubia NX809J, Snapdragon SM8850, Android 16.
- Application ID: `ai.liquid.lfmdemo`.
- Minimum Android version declared by the APK: Android 9 / API 28.
- Model: `LiquidAI/LFM2.5-Audio-1.5B-GGUF`, Q4_0 files.
- Pinned model/runner revision: `7d525f883a077e20afb782f2ff618edcae0e39e4`.
- APK: `android-app/releases/lfm-audio-demo-0.1.0-debug.apk`.
- APK SHA-256: `d9b74cd59c86446c0a536f412e03d39d4a27899063ac39e290548c400f3474c5`.

The profiling build used by the 2026-07-17 memory experiment is
`android-app/releases/lfm-audio-demo-0.2.0-profile-debug.apk` with SHA-256
`4c24a3e38575c396cd3056139da447559fb4046aa1152dff115cf043b254dc1f`.
It adds an app-private `runtime.args` hook for controlled runner flags. When
that file is absent, it behaves like the original phone-only demo.

The APK contains the Java application, embedded web UI, and official ARM64
runner libraries. The four model files are installed separately and occupy
approximately 1.0 GiB. Keep at least 3 GiB of free phone storage during
installation because the transfer temporarily creates a second copy.

## Prerequisites

1. An ARM64 Android phone with USB debugging enabled.
2. Android platform tools with `adb` on `PATH`.
3. Python 3 and `huggingface_hub` if downloading the tested model bundle:

   ```bash
   python3 -m pip install huggingface_hub
   ```

4. Review the LFM Open License before downloading or redistributing the model.
   A copy is under `android-app/third_party/LFM_OPEN_LICENSE.txt`. Its commercial
   terms include a revenue threshold.

## Install the prebuilt APK

Download the exact model files used for the published profile:

```bash
scripts/download_lfm_q4_models.sh work/models/lfm25-audio-q4
```

Connect the phone by USB, accept the Android debugging authorization prompt,
and run:

```bash
scripts/install_native_phone_demo.sh \
  --model-dir work/models/lfm25-audio-q4
```

The installer verifies all four model hashes, installs the APK, copies the
weights into Android private app storage, grants microphone permission, and
opens `LFM Audio`. Wait until its foreground notification reports that LFM is
running. You may then remove the USB cable. Recording, inference, generated
speech, and the UI all remain on the phone and do not require a Mac or network.

On phones with aggressive battery management, set `LFM Audio` to unrestricted
battery/background use before a long demo. After rebooting the phone, open the
app once to start the model service.

## Build the APK from source

Install JDK 17 and an Android SDK containing API 35. Set `ANDROID_HOME` or
`ANDROID_SDK_ROOT`, then run:

```bash
scripts/build_android_apk.sh
```

The resulting debug APK is:

```text
android-app/app/build/outputs/apk/debug/app-debug.apk
```

A locally built debug APK may not have the same whole-file hash as the supplied
APK because Gradle uses the local debug signing key and build metadata. The
committed runner and model manifests provide the content-level provenance that
matters for reproducing the measured runtime.

To rebuild and immediately install it:

```bash
scripts/build_install_phone_apk.sh \
  --model-dir work/models/lfm25-audio-q4
```

The official runner libraries are committed for reproducibility. To recreate
them from the pinned upstream archive and verify every binary hash:

```bash
scripts/refresh_android_runner.sh
```

The upstream runner and its third-party license files come from
`LiquidAI/LFM2.5-Audio-1.5B-GGUF` at the pinned revision above.

## Run the on-device profile

Profiling uses ADB to control the app and forward its phone-local API. Keep the
USB cable connected for the standard latency/memory profile:

```bash
python3 scripts/profile_native_android_app.py
```

The script performs three process restarts, one excluded warm-up per workload,
ten short-ASR runs, five long-ASR runs, and five interleaved chat runs. Override
those counts or audio paths with `--help`. Output is written beneath
`reports/android_phone/native_profile/`.

Measure process CPU time separately:

```bash
python3 scripts/probe_native_android_cpu.py \
  --runs 3 \
  --output reports/android_phone/native_profile/cpu_probe.json
```

The supplied audio files come from `vendor/liquid-audio/assets`. The complete
file is submitted before each timed request, so these measurements begin after
utterance completion. They do not include speaking time, microphone capture,
VAD, or endpoint detection.

Battery drain measured while USB or AC charging is invalid. For a power test,
enable Android Wireless debugging, establish the ADB connection, physically
unplug the phone, and record a longer controlled workload.

### Memory attribution and runtime matrices

The profiling APK supports controlled context, repack, KV, mmap, and batch
arguments without rebuilding between runs. The reusable entry points are:

```bash
python3 scripts/profile_android_memory_attribution.py --mode chat
python3 scripts/run_android_memory_matrix.py context --mode asr
python3 scripts/run_android_memory_matrix.py repack --mode asr
```

Prepare and execute the matched 18-utterance quality gate with:

```bash
python3 scripts/prepare_phone_asr_diagnostic.py
python3 scripts/run_phone_asr_diagnostic.py
```

See `reports/android_phone/experiment_batch_20260717/REPORT.md` for the memory,
latency, and WER decision from these experiments.

## Published result

The verified Nubia profile is in
`reports/android_phone/native_profile/20260716t120118z/REPORT.md`. In summary:

- 0% WER on both bundled ASR sanity samples.
- Median first generated audio: approximately 800 ms.
- Combined sampled peak RSS: approximately 2,169 MiB.
- Median generation utilization: 7.86 CPU cores.

These are CPU Q4 results on the phone above. They must not be presented as
QNN/NPU, AR1, or glasses measurements.

## Uninstall

```bash
adb uninstall ai.liquid.lfmdemo
```

Uninstalling removes the APK and the private model copies from the phone.
