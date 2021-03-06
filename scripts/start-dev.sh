#!/bin/sh
#
# Start Volt application in development mode.
#
# Starting in development mode activates the source synchronization feature
# to allow dynamic and instant updates of changes to the Volt application
# while running.
#
# Note: When running in this mode the Volt application is *NOT* precompiled.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# --- Mark the starting of Volt...

echo >>/var/log/volt.log "`date`: Starting Volt application in development mode!"
echo >>/var/log/volt.log "`date`: websocket-port: ${VOLT_PORT_HTTP:-3000}"
echo >>/var/log/volt.log "`date`: http-port: ${VOLT_PORT_HTTP:-3000}"

# --- Start periodical synchronizations in the background

/scripts/sync-src.sh &

# --- Determine which port to use for the server

# Bundle install the app and start running the Volt server
#
cd /app ; bundle install ; bundle exec volt server -p ${VOLT_PORT_HTTP:-3000}
