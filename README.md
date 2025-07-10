# Transcribe Whispers

A lightweight Bash script for audio transcription using [whisper.cpp](https://github.com/ggerganov/whisper.cpp) and FFmpeg on macOS. It supports both microphone recording and transcription of existing audio files.

## ✨ Features

- 🎤 Record audio interactively from your mic
- 🎧 Convert `.m4a` and other formats to `.wav` using FFmpeg
- 🧠 Transcribe audio using `whisper-cpp`
- 🗂 Save output as `.txt` (default)
- ⚙️ Customizable options via `config.conf`
- 🖥️ Automatically opens the transcript in TextEdit (macOS)

## 📦 Requirements

- macOS
- [FFmpeg](https://ffmpeg.org/):
  ```bash
  brew install ffmpeg
  ```
- [`whisper-cpp`](https://github.com/ggerganov/whisper.cpp):
  ```bash
  brew install whisper-cpp
  ```
- Whisper model (e.g. `ggml-large-v3.bin`):
  ```bash
  mkdir -p ~/Documents/whisper/models
  cd ~/Documents/whisper/models
  curl -O https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3.bin
  ```

## 🚀 Usage

### Transcribe an existing file

```bash
./transcribe.sh /path/to/audio.m4a
```

This will:
- Convert the file to WAV
- Transcribe it using `whisper-cpp`
- Save the transcript in `~/Documents/TranscribedNotes/filename.txt`
- Open it automatically in TextEdit

### Record from mic and transcribe

```bash
./transcribe.sh --record mynote
```

This will:
- Prompt you to press Enter to start recording
- Record audio using FFmpeg and your default mic
- Press Enter again to stop recording
- Save to `~/whisper/tmp/mynote.m4a`
- Transcribe using `whisper-cpp`
- Save output in `~/Documents/TranscribedNotes/mynote.txt`
- Open transcript in TextEdit

## ⚙️ Optional Configuration (config.conf)

Create a `config.conf` file next to `transcribe.sh` to customize Whisper options.

Example `config.conf`:

```
--language auto
--split-on-word
--max-len 65
--no-timestamps
--threads 4
```

These flags will be appended to the `whisper-cpp` call automatically.

## 📂 Output

Transcripts are saved to:

```
~/Documents/TranscribedNotes/
```

Filenames are based on the input file, e.g.:

- `mynote.txt`
- `interview.txt`
- `voice_idea.txt`

## 🧪 Troubleshooting

- If no output is generated:
  - Make sure `ffmpeg` and `whisper-cpp` are installed correctly
  - Check that your Whisper model is located at the correct path
  - Ensure you granted mic permissions (System Settings → Security & Privacy → Microphone)
- If using `--record` and nothing is captured, verify that `avfoundation` input device `:0` exists on your system (default on macOS)
- Edit the script if you want to support longer or multi-language files

