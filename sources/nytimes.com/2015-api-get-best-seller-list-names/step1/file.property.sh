# extract file name from url property
file="$(basename ${url%%\?*})"
echo "File: $file"

