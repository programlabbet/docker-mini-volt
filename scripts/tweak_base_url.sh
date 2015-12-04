#!/bin/sh
#
# Tweak the base url of a precompiled Volt application. Until the
# Volt framework supports customized base urls we need to replace
# some paths in the precompiled files.
#
# (C)Copyright by Programlabbet AB 2015 (http://www.programlabbet.se)

# --- Enter the public folder with precompiled app files

cd /app/public

# --- Loop through all js, css and html files and fix the base url

sed -ie "/\/app\//${VOLT_BASE_URL}\/app\//" `find . -iname *.js -o -iname *.css -o -iname *.html`
