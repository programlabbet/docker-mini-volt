#!/bin/bash
#
# Precompile and prepare Volt application for production mode.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# --- Set Volt production mode

export VOLT_ENV=production

# Don't use the message bus during precompilation (no more mongo errors)
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
#
# Note: This will attempt to connect to the configured mongo database but it
#       will fail doing so (most likely it isn't reachable from where you are
#       building this). It is still OK. You will get error messages regarding
#       this but the build will continue in the background and the Docker
#       build command will finished once the Volt application has been
#       precompiled. Though it could be worth reading the output twice to make
#       sure that no compilation errors have snuck into the build process
#       without being noticed.
#
bundle exec volt precompile

# --- For now ignore errors (mongodb access errors, etc.)
#
# As the mongo database is most likely not available we can't rely on the last
# error or return code from the last command to determine the success of this
# script (which is meant to be used on a CI server ideally).
#
# We quite bluntly say that we succeeded whatever actually happened.
#
# FIXME: Detect if the compilation was actually successfull
# FIXME: Remove dependency of the mongo db while compiling to avoid unecessary error messages

# All is good!
exit 0
