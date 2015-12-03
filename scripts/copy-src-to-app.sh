#!/bin/bash
#
# Perform a synchronization of the source folder to the application folder
# and exclude all unnecessary files and folders.
#
# (C)Copyright by Programlabbet AB 2015

# Make first synchronization of the source code to the app folder
rsync -aPq --delete-after --whole-file --force --delay-updates --exclude=.git --exclude=.gitignore --exclude=Dockerfile --exclude=docker-compose.yml --exclude=tmp --exclude=compiled /src/ /app/
