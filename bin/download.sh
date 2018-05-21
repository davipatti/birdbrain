#!/bin/bash

# $1 is a simple text file containing 1 xeno-canto query per line.
# E.g.: (but without the "#"s)
#
#   gen:tyto alba q>:C type:call
#   gen:motacilla flava q>:C type:call
#

while read QUERY; do

    echo "$QUERY"
    "$BIRDBRAIN_ROOT"/src/search_xeno_canto.py --download \
                                               --query "$QUERY" \
                                               --max-file-size 600000 \
                                               --directory "$BIRDBRAIN_ROOT"/data/downloads \
                                               --max-number-downloads 1000
    echo

done < "$1"
