#!/bin/bash
#
# Perform a synchronization of the source folder to the application folder
# and exclude all unnecessary files and folders.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# Synchronize/copy changes of the source folder to the application folder
rsync -aPq --delete-after --whole-file --force --delay-updates --exclude=.git --exclude=.gitignore --exclude=Dockerfile --exclude=docker-compose.yml --exclude=tmp --exclude=compiled --exclude=public /src/ /app/
