# Makefile to build and push the programlabbet/mini-volt docker image
#
# This file has been made to work primarily on Mac OSX.
#
# (C)Copyright Programlabbet AB 2015 (http://www.programlabbet.se)

# Build the mini-volt docker image
all:
	docker tag -f `docker build . | tee /dev/tty | grep "Successfully built" | cut -f3 -d " "` `cat registry-name.txt`
	docker tag -f `cat registry-name.txt` `cat registry-name.txt`:0.9.6

clean:
	docker

push:
	docker push `cat registry-name.txt`
	docker push `cat registry-name.txt`:0.9.6
