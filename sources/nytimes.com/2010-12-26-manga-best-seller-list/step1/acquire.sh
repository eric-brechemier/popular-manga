#!/bin/sh
cd "$(dirname "$0")"

. ./apiKey.property.sh
. ./url.property.sh
. ./file.property.sh

curl \
  --silent --show-error \
  --time-cond "$file" \
  --remote-time \
  --output "$file" \
  "$url"

cp "$file" ..
