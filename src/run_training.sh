#!/bin/bash

# Should be birdbrain-env python
python -c "import sys; print(sys.executable)"

python /Users/david/Library/tensorflow/tensorflow/examples/speech_commands/train.py \
    --data_url= \
    --data_dir=/Users/david/birdbrain/samples/ \
    --clip_duration_ms=3000 \
    --time_shift_ms=500 \
    --window_size_ms=100 \
    --window_stride_ms=30 \
    --wanted_words=cyanistes.caeruleus erithacus.rubecula fringilla.coelebs parus.major \
    --summaries_dir=/Users/david/birdbrain/training/retrain_logs \
    --train_dir=/Users/david/birdbrain/training/training \
    --background_volume=0.3
