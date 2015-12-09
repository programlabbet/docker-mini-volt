#!/bin/sh
#
# Start Volt application in production mode.
#
# Starting in development mode activates the source synchronization feature
# to allow dynamic and instant updates of changes to the Volt application
# while running.
#
# Note: When running in this mode the Volt application *IS* precompiled.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# --- Mark the starting of Volt...

echo >>/var/log/volt.log "`date`: Starting Volt application in production mode!"
echo >>/var/log/volt.log "`date`: websocket-port: ${VOLT_PORT_WEBSOCKET:-3000}"
echo >>/var/log/volt.log "`date`: http-port: ${VOLT_PORT_HTTP:-80}"

# --- Set Volt production mode

export VOLT_ENV=production
export RACK_ENV=production

# --- Jump to application folder

cd /app

# --- Fire up the production server on specified http port (80 per default)

bundle exec volt s -p ${VOLT_PORT_HTTP:-80}

# Currently we stop here if we fall through...
exit 0

# --- For the time beeing nginx doesn't work for us

# Using the the "normal" Volt server because thin is timing out the
# websocket connection every other minute which gives way bad impression
# on the user...
#
# FIXME: Configure Nginx in front of the Volt server to speed up the
#        static page loads.
#
# bundle exec volt server -p $VOLT_PORT

# Modify configuration and setup the correct listen port in nginx
sed -ie "s/\$VOLT_PORT_HTTP/${VOLT_PORT_HTTP:-80}/" /etc/nginx.conf
sed -ie "s/\$VOLT_PORT_WEBSOCKET/${VOLT_PORT_WEBSOCKET:-3000}/" /etc/nginx.conf
cat /etc/nginx.conf

# Use Nginx server to serve static assets
nginx -p /app/ -c /etc/nginx.conf

# Start the Volt server to handle any websocket connections
bundle exec volt server -p ${VOLT_PORT_WEBSOCKET:-3000}
