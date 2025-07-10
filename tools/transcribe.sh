#!/bin/bash

# === CONFIGURATION ===

WHISPER_BIN="whisper-cpp"
MODEL_PATH="$HOME/Documents/whisper/models/ggml-large-v3.bin"
OUTPUT_DIR="$HOME/Documents/TranscribedNotes"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_CONFIG="$SCRIPT_DIR/config.conf"

# === RECORDING MODE ===

if [[ "$1" == "--record" && -n "$2" ]]; then
  NAME="$2"
  INPUT_AUDIO="$HOME/Documents/whisper/tmp/$NAME.m4a"
  mkdir -p "$(dirname "$INPUT_AUDIO")"

  echo "🎙️ Press ENTER to start recording from microphone..."
  read
  echo "⏺️ Recording... Press ENTER again to stop."

  ffmpeg -f avfoundation -i ":0" -ac 1 -ar 16000 -y "$INPUT_AUDIO" > /dev/null 2>&1 &
  FFMPEG_PID=$!

  read
  echo "⏹️ Stopping recording..."
  kill -INT $FFMPEG_PID
  wait $FFMPEG_PID

  echo "✅ Recording saved to: $INPUT_AUDIO"
  set -- "$INPUT_AUDIO"
fi

# === VALIDATION ===

INPUT_AUDIO="$1"

if [ -z "$INPUT_AUDIO" ]; then
  echo "Usage:"
  echo "  ./transcribe.sh path/to/file.m4a"
  echo "  ./transcribe.sh --record <name>     # Start mic recording and save to ~/whisper/tmp/<name>.m4a"
  exit 1
fi

BASENAME=$(basename "$INPUT_AUDIO")
FILENAME="${BASENAME%.*}"
WAV_FILE="$SCRIPT_DIR/temp.wav"
OUTPUT_BASENAME="$OUTPUT_DIR/$FILENAME"
OUTPUT_FILE="$OUTPUT_BASENAME.txt"

# === PROCESSING ===

mkdir -p "$OUTPUT_DIR"

echo "🎧 Converting $INPUT_AUDIO to WAV..."
ffmpeg -y -i "$INPUT_AUDIO" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV_FILE" > /dev/null 2>&1

# Build whisper-cpp command
WHISPER_OPTS="--model $MODEL_PATH --file $WAV_FILE --output-file $OUTPUT_BASENAME --output-txt"

# Load config.conf if it exists
if [ -f "$DEFAULT_CONFIG" ]; then
  echo "⚙️ Using config file: $DEFAULT_CONFIG"
  CONFIG_OPTS=$(cat "$DEFAULT_CONFIG" | xargs)
  WHISPER_OPTS="$WHISPER_OPTS $CONFIG_OPTS"
fi

# Run transcription (silent)
echo "🧠 Transcribing with whisper-cpp..."
$WHISPER_BIN $WHISPER_OPTS > /dev/null 2>&1

# Check output
if [ -f "$OUTPUT_FILE" ]; then
  echo "✅ Transcript saved to: $OUTPUT_FILE"
  echo "📂 Opening transcript in TextEdit..."
  open -a TextEdit "$OUTPUT_FILE"
else
  echo "❌ Something went wrong. No output was created."
fi

# Clean up temp WAV
rm -f "$WAV_FILE"

