#!/bin/bash

while read query
do
    echo "$query"
    echo
    search_xeno_canto.py --download \
                         --query "$query" \
                         --max-file-size 600000 \
                         --directory downloads \
                         --max-number-downloads 1000
    echo
    echo
done < common2.txt
