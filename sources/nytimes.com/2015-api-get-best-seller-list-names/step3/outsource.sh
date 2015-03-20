#!/bin/sh
# Requires csvcut, from csvkit (0.9.0)
cd "$(dirname "$0")"

. ./lib/throttle.sh

# Get the number of seconds in current hour,
# to measure intervals between the first and the last request.
seconds_in_hour()
{
  echo "$(date +'%M * 60 + %S' | bc)"
}

# Compute the difference between two number of seconds in an hour.
# The second value is expected to be greater than the first, and
# less than one hour later, which allows to compute the difference
# across hour boundaries. It is not valid to measure larger intervals
# that may extend over one hour.
delta_seconds_in_hour()
{
  echo "$(( ( $2 - $1 + 3600 ) % 3600 ))"
}

# Write a message both to standard output and the file log.txt
log()
{
  echo "$1" | tee -a log.txt
}

tail -n 1 ../data.csv |
csvcut -c 1,3,4,5,6 |
csvformat -T |
if IFS='	' read listName encodedListName startDate endDate frequency
then
  rm log.txt # reset log file

  log "Start Date: $startDate"
  log "End Date: $endDate"
  log "Frequency: $frequency"

  julianStartDay="$(./lib/iso2julian.sh "$startDate")"
  julianEndDay="$(./lib/iso2julian.sh "$endDate")"

  if test "$frequency" = "WEEKLY"
  then
    daysOffset=7
  else
    log "Unsupported frequency: $frequency"
    exit 1
  fi

  log "Julian Day Start: $julianStartDay"
  julianDay="$julianStartDay"

  throttle_setMaxEventsPerSecond 8

  startSeconds="$(seconds_in_hour)"
  counter=0

  until test "$julianDay" -gt "$julianEndDay"
  do
    throttle

    echo
    counter=$(( $counter + 1 ))
    echo "Counter: $counter"

    currentSeconds="$(seconds_in_hour)"
    interval=$( delta_seconds_in_hour $startSeconds $currentSeconds )
    echo "Duration: $interval seconds"
    echo "Rate: $(( $counter / ( 1 + $interval ) )) / second"

    echo "Julian Day: $julianDay"
    isoDate="$( ./lib/julian2iso.sh "$julianDay")"
    echo "ISO Date: $isoDate"
    julianDay="$(( $julianDay + $daysOffset ))"

    folderPath="../../$isoDate-$encodedListName-best-seller-list"
    echo "Folder: $folderPath"

    fileName="$encodedListName.xml"

    mkdir -p "$folderPath/step1"
    mkdir -p "$folderPath/step2"

    url="http://api.nytimes.com/svc/books/v3/lists/$isoDate/$fileName?api-key=[your-key]"
    echo "URL: $url"

    cat << EOF > "$folderPath/meta.txt"
Attribution: Data provided by The New York Times
Year: ${isoDate%%-*}
Title: New York Times' List of $listName Best Sellers ($isoDate)
URL: $url
Documentation: http://developer.nytimes.com/docs/books_api/Books_API_Best_Sellers#h3-list
File: $fileName
EOF

    cp -p ../step1/*.sh "$folderPath/step1/"
    cp -p ../step2/parse.sh "$folderPath/step2/"
    cp -p outsource-step2-parse.xsl "$folderPath/step2/parse.xsl"
    cp -p outsource-step2-csv.xsl "$folderPath/step2/csv.xsl"

    "$folderPath/step1/acquire.sh" &&
    "$folderPath/step2/parse.sh"
  done 2>&1 | tee -a log.txt
  log "Julian Day End: $julianEndDay"
fi
