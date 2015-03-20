#!/bin/sh
# Requires: xsltproc
cd "$(dirname "$0")"

. ../step1/file.property.sh

xsltproc parse.xsl "../step1/$file" > data.csv

echo "Extracted: data.csv"
cp data.csv ..
