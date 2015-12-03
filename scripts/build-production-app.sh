#!/bin/bash
#
# Precompile and prepare Volt application for production mode.
#
# (C)Copyright by Programlabbet AB 2015

# --- Set Volt production mode
export VOLT_ENV=production

# --- Jump to application folder
cd /app

# --- Disable image compression - not supported on this docker image

# Replace any explicit enabling of image compression
sed -ie 's/\s*#.*config\.compress_images.*true/  config\.compress_images=false/' config/app.rb
# Debugging: Output the final configuration
echo "`date`: Modified config/app.rb - final configuration:"
cat config/app.rb

# --- Install dependencies
bundle install

# --- Precompile application (JS, CSS, uglify, minimize and whatnot)
bundle exec volt precompile

# --- For now ignore errors (mongodb access errors, etc.)
exit 0
