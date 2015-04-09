#!/bin/sh
cd "$(dirname "$0")"

# Combine data.csv files from a list of folders into a single file
#
# Parameters:
#   $1 - string, the pattern which matches the set of folders
#        which contain data.csv files
#        Note: surround this parameter with single quotes
#        to prevent wildcard expansion
#   $2 - string, name of the output file
combine()
{
  combine_isFirst="true"
  for folder in $1
  do
    if test "$combine_isFirst" = "true"
    then
      # write the records including header,
      # overwriting previous version of the file, if any
      sed -f prepare.sed "$folder/data.csv" > "$2"
      combine_isFirst="false"
    else
      # append the records without header
      tail -n +2 "$folder/data.csv" |
      sed -f prepare.sed >> "$2"
    fi
  done
}

# nytimes.com
sed -f prepare.sed \
  ../../sources/nytimes.com/2015-api-get-best-seller-list-names/data.csv \
> nytimes_2015_api_get_best_seller_list_names.csv
combine \
  '../../sources/nytimes.com/*-manga-best-seller-list' \
  nytimes_manga_best_seller_lists.csv
