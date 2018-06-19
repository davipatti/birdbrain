#!/bin/bash

"""
Usage:

$ split-wav.sh (optional SEGMENT_TIME: int)

Splits downloaded wav files into samples SEGMENT_TIME seconds long.

Saves split files to data/samples/"$SEGMENT_TIME"
"""

for WAV in "$BIRDBRAIN_ROOT"/data/wav/*.wav; do

    FILE=$(basename "$WAV")  # Turdus.merula.25745.A.call.wav
    GENUS_SPECIES=$(echo "$FILE" | cut -f 1-2 -d .)  # Turdus.merula
    ID=$(echo "$FILE" | cut -f 3 -d .)  # 25745

    # New syntax (to me)
    # SEGMENT_TIME can be set with the first command line argument
    # If it is absent it defaults to 3 (not -3)
    SEGMENT_TIME=${1:-3}

    OUTPUT_DIR="$BIRDBRAIN_ROOT"/data/samples/"$SEGMENT_TIME"/"$GENUS_SPECIES"
    if [ ! -d "$OUTPUT_DIR" ]; then
        mkdir -p "$OUTPUT_DIR"
    fi

    if [ ! -f "$OUTPUT_DIR"/"$ID"_nohash_000.wav ]; then
        echo Splitting "$WAV":
        ffmpeg -i "$WAV" -f segment -segment_time "$SEGMENT_TIME" -c copy -hide_banner "$OUTPUT_DIR"/"$ID"_nohash_%03d.wav

        # Remove final segment which is shorter than $SEGMENT_TIME
        rm $(ls "$OUTPUT_DIR"/"$ID"_nohash_*.wav | tail -n 1)

        echo
    else
        echo Already split: "$WAV"
        echo See: "$OUTPUT_DIR"/"$ID"_nohash_000.wav
        echo Skipping...
        echo
    fi

done