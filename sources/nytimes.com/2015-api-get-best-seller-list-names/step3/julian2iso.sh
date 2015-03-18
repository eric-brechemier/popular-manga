#!/bin/sh
# Convert a Julian Day Number to an ISO date in format 'yyyy-mm-dd'
# Note: the Julian Day Number corresponds to the ISO date at noon.
#
# == Usage ==
#
# julian2iso.sh [julian-day-number]
# echo julian-day-number | julian2iso.sh
#
# The Julian Day Number can be provided as parameter;
# otherwise, it will be read from standard input.
# The converted date is printed on standard output.
#
# == References ==
#
# Gregorian calendar from Julian day number
# https://en.wikipedia.org/wiki/Julian_day#Gregorian_calendar_from_Julian_day_number
#
# According to Wikipedia, algorithm described pp. 617-619 in
# Richards, E. G. (2013). Calendars.
# In S. E. Urban & P. K. Seidelmann, eds.
# Explanatory Supplement to the Astronomical Almanac, 3rd ed.
# (pp. 585–624).
# Mill Valley, Calif.: University Science Books.
# ISBN 978-1-89138-985-6

# Constants
y=4716
j=1401
m=2
n=12
r=4
p=1461
v=3
u=5
s=153
w=2
B=274277
C=-38

# read Julian Day Number from optional parameter
julianDayNumber="$1"
if test -z "$julianDayNumber"
then
  # if parameter is not set, then read Julian Day Number from standard input
  read -r julianDayNumber
fi

f="$((
    $julianDayNumber
  + $j
  + (
      (
        ( 4 * $julianDayNumber + $B ) / 146097
      ) * 3
    ) / 4
  + $C
))"
e="$(( $r * $f + $v ))"
g="$(( $e % $p / $r  ))"
h="$(( $u * $g + $w ))"

isoDay="$((
    $h % $s / $u
  + 1
))"
isoMonth="$((
    ( $h / $s + $m ) % $n
  + 1
))"
isoYear="$((
    $e / $p
  - $y
  + ( $n + $m - $isoMonth ) / $n
))"

if test "$isoDay" -lt 10
then
  isoDay="0$isoDay"
fi

if test "$isoMonth" -lt 10
then
  isoMonth="0$isoMonth"
fi

echo "$isoYear-$isoMonth-$isoDay"
