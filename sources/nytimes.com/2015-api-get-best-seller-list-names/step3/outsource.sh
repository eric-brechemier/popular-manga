#!/bin/sh
# Requires csvcut, from csvkit (0.9.0)
cd "$(dirname "$0")"

. ./throttle.sh

seconds_in_hour()
{
  echo "$(date +'%M * 60 + %S' | bc)"
}

delta_seconds_in_hour()
{
  echo "$(( ( $2 - $1 + 3600 ) % 3600 ))"
}

tail -n 1 ../data.csv |
csvcut -c 4,5,6 |
csvformat -T |
if IFS='	' read startDate endDate frequency
then
  echo "Start Date: $startDate"
  echo "End Date: $endDate"
  echo "Frequency: $frequency"

  julianStartDay="$(./iso2julian.sh "$startDate")"
  julianEndDay="$(./iso2julian.sh "$endDate")"

  if test "$frequency" = "WEEKLY"
  then
    daysOffset=7
  else
    echo "Unsupported frequency: $frequency"
    exit 1
  fi

  echo "Julian Day Start: $julianStartDay"
  julianDay="$julianStartDay"

  throttle_setMaxEventsPerSecond 8

  startSeconds="$(seconds_in_hour)"
  counter=0

  # TODO: check if the newest published date (in the future) must be skipped;
  #       in this case, use the while loop with the test below
  #       instead of the until loop.
  # while test "$julianDay" -lt "$julianDay"
  until test "$julianDay" -gt "$julianEndDay"
  do
    throttle

    counter=$(( $counter + 1 ))
    echo "Counter: $counter"

    currentSeconds="$(seconds_in_hour)"
    interval=$( delta_seconds_in_hour $startSeconds $currentSeconds )
    echo "Duration: $interval seconds"
    echo "Rate: $(( $counter / ( 1 + $interval ) )) / second"

    echo "Julian Day: $julianDay"
    isoDate="$( ./julian2iso.sh "$julianDay")"
    echo "ISO Date: $isoDate"
    julianDay="$(( $julianDay + $daysOffset ))"
  done
  echo "Julian Day End: $julianEndDay"
fi
