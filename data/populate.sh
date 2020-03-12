#!/bin/bash

echo "running"

# index all WARCs
cd /data/warcs

shopt -s nullglob
for filename in *.warc*; do
  #curl -X POST --data-binary @$filename http://outbackcdx:8080/testindex
  cdx-indexer $filename > ../cdx/$filename.cdx
done

# ingest CDX into OutbackCDX
cd ../cdx

shopt -s nullglob
for filename in *.cdx; do
  curl -X POST --data-binary @$filename http://outbackcdx:8080/testindex

done
