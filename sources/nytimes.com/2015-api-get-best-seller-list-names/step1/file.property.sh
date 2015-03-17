# read file name from meta.txt
file="$(grep '^File:' ../meta.txt | cut -d' ' -f2)"
echo "File: $file"

