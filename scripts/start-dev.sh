#!/bin/sh
#
# Start Volt application in development mode.
#
# (C)Copyright Programlabbet AB 2015

echo >>/var/log/volt.log "`date`: Starting Volt application in development mode!"

# Start periodical synchronizations in background (every other second)
#
/scripts/sync-src.sh &

# --- Determine which port to use for the server
#

# Default port is 3000
#
if [ "$VOLT_PORT" == "" ]; then
	export VOLT_PORT=3000
fi

# Bundle install the app and start running the Volt server
#
cd /app ; bundle install ; bundle exec volt server -p $VOLT_PORT
