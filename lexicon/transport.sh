#!/bin/sh
gzip --stdout lexicon-src.txt | base64 -w 0 | split -b 50KiB
sed -i 's/^/\#"/;s/$/"/' x*
