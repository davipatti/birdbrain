#!/bin/bash

while read query
do
    echo "$query"
    echo
    search-xeno-canto.py --download \
                         --query "$query" \
                         --max-file-size 500000 \
                         --directory downloads \
                         --max-number-downloads 1000
    echo
    echo
done < common.txt
