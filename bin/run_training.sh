#!/bin/bash

# Show which python is being used
echo python is $(which python)

# _background_noise_ from download.tensorflow.org/data/speech_commands_v0.02.tar.gz
ln -sf "$BACKGROUND_NOISE" "$BIRDBRAIN_ROOT"/data/samples/_background_noise_

DATETIME=$(date +%y%m%d_%H%M%S)

python "$TENSORFLOW_SRC_ROOT"/tensorflow/examples/speech_commands/train.py \
    --data_url= \
    --data_dir="$BIRDBRAIN_ROOT"/data/samples/ \
    --clip_duration_ms=3000 \
    --time_shift_ms=500 \
    --window_size_ms=100 \
    --window_stride_ms=30 \
    --wanted_words=periparus.ater,chloris.chloris,pica.pica,pyrrhula.pyrrhula,passer.domesticus,aegithalos.caudatus,fringilla.coelebs,erithacus.rubecula,parus.major,motacilla.flava,cyanistes.caeruleus,phylloscopus.collybita,troglodytes.troglodytes,garrulus.glandarius,turdus.merula \
    --summaries_dir="$BIRDBRAIN_ROOT"/training/"$DATETIME"/summaries_dir \
    --train_dir="$BIRDBRAIN_ROOT"/training/"$DATETIME"/train_dir \
    --background_volume=0.3
