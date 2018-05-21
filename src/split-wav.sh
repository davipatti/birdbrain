#!/bin/bash
for WAV in "$BIRDBRAIN_ROOT"/data/wav/*.wav; do
    FILE=$(basename "$WAV")  # Turdus.merula.25745.A.call.wav
    GENUS_SPECIES=$(echo "$FILE" | cut -f 1-2 -d .)  # Turdus.merula
    ID=$(echo "$FILE" | cut -f 3 -d .)  # 25745
    OUTPUT_DIR="$BIRDBRAIN_ROOT"/data/samples/"$GENUS_SPECIES"
    if [ ! -d "$OUTPUT_DIR" ]; then
        mkdir -p "$OUTPUT_DIR"
    fi
    if [ ! -f "$OUTPUT_DIR"/"$ID"_nohash_000.wav ]; then
        ffmpeg -i "$WAV" -f segment -segment_time 3 -c copy -hide_banner "$OUTPUT_DIR"/"$ID"_nohash_%03d.wav
        else
        echo Already split "$WAV". Skipping.
    fi
done