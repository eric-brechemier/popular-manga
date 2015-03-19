#!/bin/sh
# Requires csvcut, from csvkit (0.9.0)
cd "$(dirname "$0")"

# Return the number of seconds since the start of current hour
seconds_in_hour()
{
  echo "$(date +'%M * 60 + %S' | bc)"
}

# Return the difference between two numbers of seconds in an hour.
# The second value is considered to correspond to a date less than
# one hour later than the first value, which allows to compute the
# difference across hour boundaries.
# This method is intended to measure intervals ranging from less than
# a second (but without the subsecond granularity) to a few seconds.
# It remains valid for intervals smaller than 1 hour.
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

  startSeconds="$(seconds_in_hour)"
  counter=0

  # TODO: check if the newest published date (in the future) must be skipped;
  #       in this case, use the while loop with the test below
  #       instead of the until loop.
  # while test "$julianDay" -lt "$julianDay"
  until test "$julianDay" -gt "$julianEndDay"
  do
    echo "Julian Day: $julianDay"

    counter=$(( $counter + 1 ))
    currentSeconds="$(seconds_in_hour)"
    interval=$( delta_seconds_in_hour $startSeconds $currentSeconds )
    echo "Rate: $(( $counter / (1+$interval) )) / second"

    isoDate="$( ./julian2iso.sh "$julianDay")"
    echo "ISO Date: $isoDate"
    julianDay="$(( $julianDay + $daysOffset ))"
  done
  echo "Julian Day End: $julianEndDay"
fi
