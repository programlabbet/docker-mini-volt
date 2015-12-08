#!/bin/bash
#
# Precompile and prepare Volt application for production mode.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# --- Set Volt production mode

export VOLT_ENV=production

# --- Jump to application folder

cd /app

# --- Disable image compression - not supported in this docker image
#
# This however seems to errorenously omit *all* image assets from the
# public folder which is not really something that we want to do.
#
# So in order to get this working we need to copy the images explicitly
# as a last step after the precompile is done.
#

# Replace any explicit enabling of image compression
sed -ie 's/\s*#.*config\.compress_images.*true/  config\.compress_images=false/' config/app.rb
# Debugging: Output the final configuration for inspection
echo "`date`: Modified config/app.rb - final configuration:"
cat config/app.rb

# --- Install dependencies (this is useful to save on app launching time)

bundle install

# --- Precompile application (JS, CSS, uglify, minimize and whatnot)

# Do not currently precompile as it is not working correctly
# (socket reconnect is not working as expected)
#
# FIXME: NO_MESSAGE_BUS=true bundle exec volt precompile

# --- Explicitly copy main component image assets to public folder

#mkdir -p public/app/main/assets/images
#cp -a app/main/assets/images/* public/app/main/assets/images/
