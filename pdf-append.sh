#!/bin/sh
# caution: files with spaces in names are forbidden
if [ $# -lt 2 ]; then
    echo "usage: $0 <file> <files to append>"
    exit 1
fi
pdftk $@ cat output /tmp/pdf-append-tmp.pdf && \
mv /tmp/pdf-append-tmp.pdf "$1" && \
shift && \
rm $@
