#!/bin/sh
#
# Tweak the base url of a precompiled Volt application. Until the
# Volt framework supports customized base urls we need to replace
# some paths in the precompiled files.
#
# (C)Copyright by Programlabbet AB 2015 (http://www.programlabbet.se)

# --- Enter the public folder with precompiled app files

cd /app/public

# --- Debug

echo "**** DEBUG --- VOLT_BASE_URL: $VOLT_BASE_URL"

# --- Loop through all js, css and html files and fix the base url

sed -ie "s#\"/app/#\"$VOLT_BASE_URL/app/#g" `find . -iname *.js -o -iname *.css -o -iname *.html`
sed -ie "s#href:\"/#href:\"$VOLT_BASE_URL/#g" `find . -iname *.js -o -iname *.html`
sed -ie "s#\$client.\"/#\$client\(\"$VOLT_BASE_URL/#g" `find . -iname *.js`
#sed -ie "s#websocket_url:\"/socket\"#websocket_url:\"$VOLT_BASE_URL/socket\"#g" `find . -iname *.js`
sed -ie "s#\"/socket\"#\"$VOLT_BASE_URL/socket\"#g" `find . -iname *.js`

# --- Debug output

cat `find . -iname *.html -o -iname *.js`
