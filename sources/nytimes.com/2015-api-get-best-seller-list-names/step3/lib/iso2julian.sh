#!/bin/sh
# Convert an ISO date in format 'yyyy-mm-dd' to a Julian Day Number
# Note: the Julian Day Number corresponds to the ISO date at noon.
#
# == Usage ==
#
# iso2julian.sh [yyyy-mm-dd]
# echo yyyy-mm-dd | iso2julian.sh
#
# The ISO date can be provided as parameter;
# otherwise it will be read from standard input.
# The converted date is printed to standard output.
#
# == References ==
#
# Converting Julian or Gregorian calendar date to Julian Day Number
# https://en.wikipedia.org/wiki/Julian_day#Converting_Julian_or_Gregorian_calendar_date_to_Julian_Day_Number
#
# Explanation of Julian Day Number Calculation
# http://www.cs.utsa.edu/~cs1063/projects/Spring2011/Project1/jdn-explanation.html

# read ISO date from optional parameter
isoDate="$1"
if test -z "$isoDate"
then
  # if parameter is not set, then read ISO date from standard input
  read -r isoDate
fi

# split ISO date on dash
IFS='-'
set $isoDate
isoYear="$1"
isoMonth="$2"
isoDay="$3"

# whether the month is January or February (true=1, false=0)
oneIfBeforeMarch="$(( (14 - $isoMonth) / 12 ))"

# number of years since March 1, 4801 BC
yearOffset="$(( $isoYear + 4800 - $oneIfBeforeMarch ))"

# number of months since March
monthOffset="$(( $isoMonth + 12 * $oneIfBeforeMarch - 3 ))"

julianDayNumber="$((
    $isoDay
  + ( 153 * $monthOffset + 2 ) / 5
  + 365 * $yearOffset
  + $yearOffset / 4
  - $yearOffset / 100
  + $yearOffset / 400
  - 32045
))"
echo "$julianDayNumber"
