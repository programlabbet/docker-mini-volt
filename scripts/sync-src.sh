#!/bin/sh
#
# Periodically sync source folder with running app folder
#
# Doing it this way makes it possible for Volt to detect source changes and
# dynamically update the application without reloading the page. In short
# we can take advantage of Volt's built in ability for live reload and stuff.
#
# (C)Copyright Programlabbet AB 2015

# Create inboxes for incoming changes
mkdir -p /inbox

while true; do
	# Copy incoming changes in two steps because a file change is
	# detected by the OS before the file has been completely synced
	# from the src to the app folder (going over the VM shared files)
	# and results in invalid/half copied files.
	#

	# Step 1:
	# Catch incoming changes...
	rsync >/dev/null -aPq --delete --force --exclude=.git --exclude=public --exclude=tmp --exclude=compiled /src/ /inbox/

	# Step 2:
	# Copy files locally in filesystem
	rsync >/dev/null -aPq --delete-after --whole-file --force --delay-updates --exclude=.git --exclude=public --exclude=tmp --exclude=compiled /inbox/ /app/

	# Wait for a few seconds before synchronizing files again
	sleep 5
done
