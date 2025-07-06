# Transcribe whispers
A lightweight Bash script for automatic audio transcription using [whisper.cpp](https://github.com/ggerganov/whisper.cpp).

This tool is ideal for converting short recordings (e.g., voice notes from QuickTime) into clean transcripts using OpenAI's Whisper models locally.

## Features

- 🎧 Converts `.m4a` (or other formats) to `.wav` using FFmpeg
- 🧠 Transcribes using `whisper-cpp` or `whisper-cli`
- 🗂️ Saves output as `.txt`, `.vtt`, `.srt`, or `.json`
- ⚙️ Uses a simple `config.conf` for Whisper parameters
- 🖥️ Opens the result in TextEdit (macOS)

## Prerequisites

- macOS
- [FFmpeg](https://ffmpeg.org/) — `brew install ffmpeg`
- [`whisper-cpp`](https://github.com/ggerganov/whisper.cpp) — `brew install whisper-cpp` or `whisper-cli`
- A Whisper model (e.g. `ggml-large-v3.bin`) stored locally

## Usage

```bash
./transcribe.sh /path/to/audio.m4a
