#!/bin/sh
cd "$(dirname $0)"

. ./apiKey.property.sh

# read URL from meta.txt and replace API Key
url=$(
  grep '^URL:' ../meta.txt |
  cut -d' ' -f2 |
  sed "s/\[your-key\]/$apiKey/"
)
echo "URL: $url"

file="$(basename ${url%%\?*})"
echo "File: $file"

wget -O "$file" "$url"

cp "$file" ..
