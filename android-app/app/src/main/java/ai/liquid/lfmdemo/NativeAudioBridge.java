package ai.liquid.lfmdemo;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.util.Base64;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

final class NativeAudioBridge {
    private static final String TAG = "LfmNativeAudio";
    private static final int SAMPLE_RATE = 16_000;
    private static final int MAX_SECONDS = 30;

    private final Context context;
    private final WebView webView;
    private final Object lock = new Object();
    private AudioRecord recorder;
    private Thread recordingThread;
    private volatile boolean recording;
    private ByteArrayOutputStream pcm;

    NativeAudioBridge(Context context, WebView webView) {
        this.context = context.getApplicationContext();
        this.webView = webView;
    }

    @JavascriptInterface
    public boolean startRecording() {
        synchronized (lock) {
            if (recording) {
                return true;
            }
            if (context.checkSelfPermission(Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                sendError("Android microphone permission is not granted.");
                return false;
            }
            int minimum = AudioRecord.getMinBufferSize(
                    SAMPLE_RATE,
                    AudioFormat.CHANNEL_IN_MONO,
                    AudioFormat.ENCODING_PCM_16BIT
            );
            int bufferSize = Math.max(4096, minimum * 2);
            try {
                recorder = new AudioRecord(
                        MediaRecorder.AudioSource.VOICE_RECOGNITION,
                        SAMPLE_RATE,
                        AudioFormat.CHANNEL_IN_MONO,
                        AudioFormat.ENCODING_PCM_16BIT,
                        bufferSize
                );
                if (recorder.getState() != AudioRecord.STATE_INITIALIZED) {
                    throw new IllegalStateException("AudioRecord initialization failed");
                }
                pcm = new ByteArrayOutputStream(SAMPLE_RATE * 2 * 8);
                recording = true;
                recorder.startRecording();
                recordingThread = new Thread(() -> capture(bufferSize), "lfm-microphone");
                recordingThread.start();
                return true;
            } catch (RuntimeException error) {
                Log.e(TAG, "Could not start recording", error);
                cleanupRecorder();
                sendError(error.getMessage());
                return false;
            }
        }
    }

    @JavascriptInterface
    public void stopRecording() {
        AudioRecord active;
        synchronized (lock) {
            if (!recording) {
                return;
            }
            recording = false;
            active = recorder;
        }
        try {
            active.stop();
        } catch (IllegalStateException ignored) {
        }
        Thread thread = recordingThread;
        if (thread != null) {
            try {
                thread.join(1500);
            } catch (InterruptedException error) {
                Thread.currentThread().interrupt();
            }
        }
        byte[] captured;
        synchronized (lock) {
            captured = pcm == null ? new byte[0] : pcm.toByteArray();
            cleanupRecorder();
        }
        if (captured.length == 0) {
            sendError("No microphone samples were captured.");
            return;
        }
        byte[] wav = makeWav(captured);
        String encoded = Base64.encodeToString(wav, Base64.NO_WRAP);
        webView.post(() -> webView.evaluateJavascript(
                "window.onNativeRecording(" + JSONObject.quote(encoded) + ")",
                null
        ));
    }

    void release() {
        if (recording) {
            stopRecording();
        } else {
            synchronized (lock) {
                cleanupRecorder();
            }
        }
    }

    private void capture(int bufferSize) {
        byte[] buffer = new byte[bufferSize];
        int maximum = SAMPLE_RATE * 2 * MAX_SECONDS;
        while (recording && pcm.size() < maximum) {
            int read = recorder.read(buffer, 0, buffer.length);
            if (read > 0) {
                pcm.write(buffer, 0, read);
            } else if (read < 0) {
                Log.e(TAG, "AudioRecord read error " + read);
                break;
            }
        }
        if (recording) {
            webView.post(() -> webView.evaluateJavascript("window.stopNativeRecordingFromLimit()", null));
        }
    }

    private void cleanupRecorder() {
        recording = false;
        if (recorder != null) {
            recorder.release();
            recorder = null;
        }
        recordingThread = null;
    }

    private void sendError(String message) {
        String safe = message == null ? "Unknown microphone error" : message;
        webView.post(() -> webView.evaluateJavascript(
                "window.onNativeRecordingError(" + JSONObject.quote(safe) + ")",
                null
        ));
    }

    private static byte[] makeWav(byte[] pcm) {
        ByteArrayOutputStream output = new ByteArrayOutputStream(44 + pcm.length);
        try {
            writeAscii(output, "RIFF");
            writeLe32(output, 36 + pcm.length);
            writeAscii(output, "WAVEfmt ");
            writeLe32(output, 16);
            writeLe16(output, 1);
            writeLe16(output, 1);
            writeLe32(output, SAMPLE_RATE);
            writeLe32(output, SAMPLE_RATE * 2);
            writeLe16(output, 2);
            writeLe16(output, 16);
            writeAscii(output, "data");
            writeLe32(output, pcm.length);
            output.write(pcm);
        } catch (IOException impossible) {
            throw new AssertionError(impossible);
        }
        return output.toByteArray();
    }

    private static void writeAscii(ByteArrayOutputStream output, String text) throws IOException {
        output.write(text.getBytes(StandardCharsets.US_ASCII));
    }

    private static void writeLe16(ByteArrayOutputStream output, int value) {
        output.write(value & 0xff);
        output.write((value >>> 8) & 0xff);
    }

    private static void writeLe32(ByteArrayOutputStream output, int value) {
        output.write(value & 0xff);
        output.write((value >>> 8) & 0xff);
        output.write((value >>> 16) & 0xff);
        output.write((value >>> 24) & 0xff);
    }
}
