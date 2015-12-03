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

# --- Start periodical synchronizations in the background

/scripts/sync-src.sh &

# --- Determine which port to use for the server

# Default port is 3000 if none other has been set
#
if [ "$VOLT_PORT" == "" ]; then
	export VOLT_PORT=3000
fi

# Bundle install the app and start running the Volt server
#
cd /app ; bundle install ; bundle exec volt server -p $VOLT_PORT
