# BirdBrain

This repo contains code to search the Xeno-canto bird sound database, and train a machine learning model to classify birds according to those sounds.

## Installation

Clone this repo and `cd` into the repositories root directory.

FFMPEG is required for audio processing.
~~~bash
$ brew install ffmpeg
~~~

Install python libraries. (This repo has bee tested using python 3.6.5.)
~~~bash
$ pip install -r requirements.txt
~~~

To use the shell scripts in `bin` for downloading and processing the data, and then training a model, these environment variables should be set:
* `BIRDBRAIN_ROOT` should point to this repositories root directory.
* `TENSORFLOW_SRC_ROOT` should point to the tensor flow source code root directory.
* `BACKGROUND_NOISE` should point to the `_background_noise_` which is downloadable from [here](download.tensorflow.org/data/speech_commands_v0.02.tar.gz).

## Download recordings from Xeno-canto

`bin/search_xeno_canto.py --help` shows command line options:

~~~
usage: search_xeno_canto.py [-h] [-q QUERY] [-d] [-m MAXSIZE]
                            [-n MAXNDOWNLOADS] [-p DIRECTORY]

Search for bird song recordings from https://www.xeno-canto.org that match a
query.

optional arguments:
  -h, --help            show this help message and exit
  -q QUERY, --query QUERY
                        Query. See https://www.xeno-canto.org/help/search for
                        details. Example: "gen: columba sp: palumbus q > : C"
  -d, --download        Download records that match the query.
  -m MAXSIZE, --max-file-size MAXSIZE
                        Only download files smaller than max-file-size bytes.
  -n MAXNDOWNLOADS, --max-number-downloads MAXNDOWNLOADS
                        Maximum number of files to download.
  -p DIRECTORY, --directory DIRECTORY
                        Directory to save downloads.
~~~

An example search:

~~~bash
src/search_xeno_canto.py --download \
                         --query "Wood pigeon" \
                         --max-file-size 600000 \
                         --directory data/downloads \
                         --max-number-downloads 1000
~~~

A batch of queries can be searched using `bin/download.sh batch.txt`. `batch.txt` contains one query per line. `common.txt` is an example.

## Convert and split

Recording have to be converted to 16-bit little-endian PCM-encoded WAVE format. This is done by `bin/mpeg-to-wav.sh` which converts mpeg files in `data/downloads` and puts them in `data/wav`.

All recordings are then split into 3 second segments using `bin/split-wav.sh`. This is a constraint of the machine learning model that is used. Segmented files are stored in `data/samples/GEN_SP` where `GEN_SP` corrseponds to the genus and species of each recording.

## Model training

Training uses TensorFlow, and specifically the model outlined and implemented [here](https://www.tensorflow.org/versions/master/tutorials/audio_recognition). This model is run using `bin/run_training.sh`. To understand the output of the model, follow training progress, and produce a simple app for android smartphones, see more details on the TensorFlow tutorial, linked above.

