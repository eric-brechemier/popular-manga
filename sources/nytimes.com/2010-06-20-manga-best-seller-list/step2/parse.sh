#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

. ../step1/file.property.sh

xsltproc parse.xsl "../step1/$file" |
xsltproc xml2csv.xsl - \
> data.csv

echo "Extracted: data.csv"
cp data.csv ..
