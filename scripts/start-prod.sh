#!/bin/sh
#
# Start Volt application in production mode.
#
# (C)Copyright Programlabbet AB 2015

echo >>/var/log/volt.log "`date`: Starting Volt application in production mode!"

# --- Set Volt production mode
#
export VOLT_ENV=production

# --- Determine which port to use for the server
#

# Default port is 3000
#
if [ "$VOLT_PORT" == "" ]; then
	export VOLT_PORT=3000
fi

# --- Jump to application folder
#
cd /app

# --- Fire up the production server on port 3000
#
# bundle exec thin start -p 3000 -e production

# Trying out the "normal" Volt server because thin is timing out the
# websocket connection every other minute which gives way bad impression
# on the user...
#
# FIXME: Configure Nginx in front of the Volt server to speed up the
#        static page loads.
#
bundle exec volt server -p $VOLT_PORT
