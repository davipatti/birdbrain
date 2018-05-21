#!/bin/bash

file=$(basename "$1")  # Turdus.merula.25745.A.call.mpeg
gen_sp=$(echo "$file" | cut -f 1-2 -d .)  # Turdus.merula
id=$(echo "$file" | cut -f 3 -d .)  # 25745
dir="samples/$gen_sp"  # samples/Turdus.merula

if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
fi

tmp=$(mktemp /tmp/XXXXX).wav
echo $tmp
echo

# Convert to 16-bit little-endian PCM-encoded WAVE format
ffmpeg -i "$1"       \
        -acodec pcm_s16le \
        -ac 1             \
        -ar 16000         \
        -y                \
        -hide_banner      \
        $tmp

# f format
# acodec audio codec
# ac audio channels
# ar audio sample rate
# y overwrites

# Split
ffmpeg -i $tmp      \
        -f segment      \
        -segment_time 3 \
        -c copy         \
        -hide_banner    \
        "$dir/"$id"_nohash_%03d.wav"

# Delete last which will not be full length
rm -f $(ls -tr $dir/*.wav | tail -n 1)
rm -f $tmp
echo
echo
