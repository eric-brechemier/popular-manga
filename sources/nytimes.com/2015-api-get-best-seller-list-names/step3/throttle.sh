#!/bin/sh
# Throttle (limit the rate) of a stream of events
# by introducing (sleep) delays of 1 second.
#
# Usage:
# 1. Call throttle_setMaxEventsPerSecond() with the maximum number of
#    events allowed per second as argument, just once
# 2. In your loop, call throttle() without argument before each event,
#    for example, to limit the rate of requests to an API, before each
#    call to the API.
#
# A call to throttle results either in no delay or a 1 second delay
# to keep the number of events below the maximum value configured.

# Boolean values true and false
throttle_true="T"
throttle_false="F"

# Get the time, formatted to track 'current second' over time
# The time using this format loops every 24 hours;
# no interval of more than one day is expected.
throttle_getTime()
{
  date +%H%M%S
}

# Reset Throttling, initially or before a 1 second sleep
throttle_reset()
{
  throttle_totalEventsSinceLastSleep=0
  throttle_totalEventsInCurrentSecond=0
  throttle_isThrottlingNeeded=$throttle_false
  throttle_previousTime="$( throttle_getTime )"
  throttle_currentTime="$( throttle_getTime )"
}

throttle_reset

# Set the maximum number of events allowed per second
#
# Parameter
#   $1 - integer, maximum number of events expected in one second
throttle_setMaxEventsPerSecond()
{
  throttle_maxEventsPerSecond="$1"

  # Given the lack of accuracy of POSIX time utility,
  # the limit is halved and no more than half of the maximum
  # number of events are allowed in a given second;
  # this prevents potentially exceeding the limit
  # over a sliding window of one second.
  throttle_halfLimit="$(( $throttle_maxEventsPerSecond / 2 ))"
}

# set maximum number of events to 1 by default
throttle_setMaxEventsPerSecond 1

# Increment the number of events
# This method is called internally in throttle().
throttle_incrementEvents()
{
  throttle_totalEventsSinceLastSleep="$((
    $throttle_totalEventsSinceLastSleep + 1
  ))"

  throttle_currentTime="$( throttle_getTime )"
  if test "$throttle_currentTime" = "$throttle_previousTime"
  then
    throttle_totalEventsInCurrentSecond="$((
      $throttle_totalEventsInCurrentSecond + 1
    ))"
  else
    throttle_totalEventsInCurrentSecond=1
    throttle_previousTime="$throttle_currentTime"
  fi
}

# Throttle a stream of events by introducing 1 second delays
# to keep the number of events per second below the maximum value
# configured by calling throttle_setMaxEventsPerSecond(), or 1 by default.
throttle()
{
  throttle_incrementEvents

  if test "$throttle_totalEventsInCurrentSecond" -gt "$throttle_halfLimit"
  then
    throttle_isThrottlingNeeded=$throttle_true
  fi

  if test "$throttle_isThrottlingNeeded" = "$throttle_true" \
  -a "$throttle_totalEventsSinceLastSleep" -gt "$throttle_maxEventsPerSecond"
  then
    throttle_reset
    sleep 1
    throttle_incrementEvents
  fi
}
