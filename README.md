# BirdBrain

This repo contains code to search the [Xeno-canto](https://www.xeno-canto.org/) bird sound database, and train a machine learning model to classify birds according to those sounds.

## Setup

FFMPEG is required for audio processing.

On OS X this can be downloaded and installed using Homebrew:
~~~bash
$ brew install ffmpeg
~~~

Clone this repo and `cd` into the repositories root directory.

Install python libraries. (This repo has bee tested using python 3.6.5.)

~~~bash
$ pip install -r requirements.txt
~~~

To use the shell scripts for downloading and processing data, and training a model, set these environment variables:

* `BIRDBRAIN_ROOT` should point to this repositories root directory.
* `TENSORFLOW_SRC_ROOT` should point to the tensor flow source code root directory.
* `BACKGROUND_NOISE` should point to the `_background_noise_` directory which is downloadable here: download.tensorflow.org/data/speech_commands_v0.02.tar.gz.

## Download recordings

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

A batch of queries can be searched using `bin/download.sh batch.txt`. Here `batch.txt` is a text file containing one query per line. See `common.txt` for an example.

## Convert and split

Recording have to be converted to 16-bit little-endian PCM-encoded WAVE format. This is done by `bin/mpeg-to-wav.sh` which converts mpeg files in `data/downloads` and puts them in `data/wav`.

Recordings are then split into 3 second segments using `bin/split-wav.sh`. This is a constraint of the machine learning model that is used, which requires training samples of a similar length of time. Segmented files are saved to `data/samples/GEN_SP` where `GEN_SP` corrseponds to the genus and species of each recording.

## Model training

Training uses TensorFlow, and specifically the model outlined and implemented in this [tutorial](https://www.tensorflow.org/versions/master/tutorials/audio_recognition). Training is run by using `bin/run_training.sh`. To understand the output of the model, follow training progress, and produce a simple app for android smartphones, see more details on the TensorFlow tutorial, linked above.

Run `"$TENSORFLOW_SRC_ROOT"/tensorflow/examples/speech_commands/train.py --help` to see command line options available.
