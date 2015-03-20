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

tail -n 1 ../data.csv |
csvcut -c 4,5,6 |
csvformat -T |
if IFS='	' read startDate endDate frequency
then
  echo "Start Date: $startDate"
  echo "End Date: $endDate"
  echo "Frequency: $frequency"

  julianStartDay="$(./lib/iso2julian.sh "$startDate")"
  julianEndDay="$(./lib/iso2julian.sh "$endDate")"

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
  done
  echo "Julian Day End: $julianEndDay"
fi
