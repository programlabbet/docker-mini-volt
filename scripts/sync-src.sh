#!/bin/sh
#
# Periodically sync source folder with running app folder.
#
# Why is this needed?
#
# The Volt server is unable to detect changes in a Volume folder mapped
# inside the container. The underlying file system doesn't support monitoring
# of changed files. So when running in development mode you want to take
# advantage of the auto-reloading of the server and the live-reload feature
# of the application. There are still some hickups where the inotify-rb
# gem crashes sometimes when a change is detected but it works, mostly.
#
# rsync is used to minimize the transfer needed for keeping the source folder
# up-to-date.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# Create inboxes for incoming changes
mkdir -p /inbox

# Loop endlessly until our universe collapses...
while true; do
	# Copy incoming changes in two steps because a file change is
	# detected by the OS before the file has been completely synced
	# from the src to the app folder (going over the VM shared files)
	# and results in invalid/half copied files. This is mostly due to
	# how the rsync-protocol copies the files.
	#
	# The first step will pull in any changes.
	#
	# The second step will as quickly and atomically as possible copy all
	# changes to the application folder where the Volt server will detect
	# those changes and initiate a reload/refresh.
	#

	# Step 1: Transfer incoming changes
	rsync >/dev/null -aPq --delete --force --exclude=.git --exclude=public --exclude=tmp --exclude=compiled /src/ /inbox/

	# Step 2: Quickly copy files locally to app folder
	rsync >/dev/null -aPq --delete-after --whole-file --force --delay-updates --exclude=.git --exclude=public --exclude=tmp --exclude=compiled /inbox/ /app/

	# Wait for a few seconds before attempting to synchronize files once more
	#
	# We're aiming at a sweet spot here - not to demanding on the system but
	# still provide a sense of quick and instant updates/refreshes.
	#
	sleep 4
done
