#!/bin/bash

# Convert downloaded mpegs to wav format

OUTPUT_DIR=$BIRDBRAIN_ROOT/data/wav
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

for MPEG in $BIRDBRAIN_ROOT/data/downloads/*.mpeg
do
    WAV=$OUTPUT_DIR/$(basename "${MPEG%.*}.wav")
    if [ ! -f "$WAV" ]; then
        ffmpeg -i "$MPEG" -acodec pcm_s16le -ac 1 -ar 16000 -y -hide_banner "$WAV"
        else
        echo "$WAV" already exists. Skipping.
    fi
done