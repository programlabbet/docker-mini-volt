#!/bin/bash
#
# Precompile and prepare Volt application for production mode.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# --- Set Volt production mode

export VOLT_ENV=production

# This will remove previous mongo db connection errors
export NO_MESSAGE_BUS=true

# --- Jump to application folder

cd /app

# --- Disable image compression - not supported in this docker image

# Replace any explicit enabling of image compression
sed -ie 's/\s*#.*config\.compress_images.*true/  config\.compress_images=false/' config/app.rb
# Debugging: Output the final configuration for inspection
echo "`date`: Modified config/app.rb - final configuration:"
cat config/app.rb

# --- Install dependencies

bundle install

# --- Precompile application (JS, CSS, uglify, minimize and whatnot)

bundle exec volt precompile
