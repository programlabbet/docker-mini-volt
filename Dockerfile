# Minimal Volt runtime image that can be used for production and/or
# development. The image contains convenience scripts and extra stuff
# to aid development and production deployment.
#
# (C)Copyright Programlabbet AB 2015

FROM programlabbet/mini-ruby:2.1.5-r1
MAINTAINER Anders Hansson <anders@programlabbet.se>

# Install the volt gem
RUN gem install volt
RUN gem install thin

# Install node-js (used for precompiling)
RUN apk --update add nodejs

# Install additional useful packages used in production mode
RUN apk --update add libjpeg-turbo-utils libjpeg

# Make sure tmp folder exists
RUN mkdir -p /tmp

# Use tmp as our workdir when building/copying/unpacking binaries
WORKDIR /tmp

# Install pngcrush
ADD files/pngcrush-1.7.88.tar.gz .
WORKDIR /tmp/pngcrush-1.7.88
RUN make && cp pngcrush /usr/bin/.

# Install jpegoptim
#ADD files/jpegoptim-1.4.3.tar.gz /tmp/
#WORKDIR /tmp/jpegoptim-1.4.3
#RUN ./configure && make && make install

# Install jpeg-archive files
ADD files/jpeg-archive-2.1.1-linux.tar.bz2 /usr/bin/

# Install pngout
WORKDIR /tmp
ADD files/pngout-20150319-linux-static.tar.gz .
RUN cp pngout-20150319-linux-static/x86_64/pngout-static /usr/bin/pngout

# Remove temporary build files
RUN rm -rf /tmp/*

# Restore workdir
WORKDIR /

# Install svgo
RUN npm install -g svgo

# Install image_optim packages (with binary package activated)
RUN gem install image_optim_pack
RUN gem install image_optim

# Create paths for source (/src). Should be mapped to project root folder.
RUN mkdir -p /src

# Add some convenience scripts for starting/stopping/building the application.
ADD scripts scripts/
RUN chmod a+rx /scripts/*

# Define the default ENTRYPOINT to start synchronizations and development mode
#
# By default this entrypoint will start in development mode as stated above,
# although it *is* possible to start it in production mode.
#
# This entrypoint is *only* used if this image is not used as a base image
# for a production build. It can be used to build a production app when starting
# without defining a specific Dockerfile deriving from this image.
#
# It is however recommended that you do a complete prebuild and prepare of the
# production Volt application in your derived Dockerfile and separate image that
# is then deployed to your production server. Because any building errors/problems
# would not show up until you actually do the build. Rather handle those on the
# build server than on the production server.
#
# This option is provided to make it easier/quicker/faster to move forward to
# a production state for non-critical applications that you may want to deploy
# by simply doing a 'git pull' and then restart the container. YMMV!

ENTRYPOINT sh -c '\
	/scripts/copy-src-to-app.sh;\
	if [ "$PRODUCTION_ENV" == "true" ]; then\
		/scripts/build-production-app.sh;\
		/scripts/start-prod.sh;\
	else\
		/scripts/start-dev.sh;\
	fi'

# ============================================================================
#
# ONBUILD downstream build process
#
# Add ONBUILD steps to automatically build a production Volt application
# by just depending on this image.

# Add the application SOURCE code
ONBUILD COPY . /app

# Remove unecessary files and folders (like .git and caches)
ONBUILD WORKDIR /app
ONBUILD RUN rm -rf .git .gitignore Dockerfile docker-compose.yml tmp compiled

# Map the src folder to the app folder
ONBUILD RUN sh -c '/scripts/build-production-app.sh'

# Add production entrypoint
ONBUILD ENTRYPOINT sh -c '/scripts/start-prod.sh'
