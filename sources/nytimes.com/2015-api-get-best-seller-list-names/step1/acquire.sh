#!/bin/sh
cd "$(dirname $0)"

. ./apiKey.property.sh
. ./url.property.sh
. ./file.property.sh

wget -O "$file" "$url"

cp "$file" ..
