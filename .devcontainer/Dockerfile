################################################################
# ColdBox Docker Image
# You can use this docker image to build your own
# You can use the following to build the image
# docker build --no-cache -t my-coldbox-app -f ./Dockerfile ./
# You can use the following to run the image
# docker run -it -p 8080:8080 my-coldbox-app
################################################################

# We pull the latest image, you can change this to a specific tag or CFML engine, which we recommend.
# https://hub.docker.com/r/ortussolutions/commandbox
FROM ortussolutions/commandbox

# Metadata
LABEL maintainer "Ortus Solutions <info@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Utility Packages for our buidling goodness
ENV PACKAGES "ca-certificates openssl openssh-client git mysql-server"

# Install Common Dependency Binaries
RUN echo "mysql-community-server mysql-community-server/root-pass password soapbox" | debconf-set-selections \
    && echo "mysql-community-server mysql-community-server/re-root-pass password soapbox" | debconf-set-selections \
    && export DEBIAN_FRONTEND=noninteractive \
    && export RUNLEVEL=1 \
    && printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d \
    && apt-get update && apt-get install --no-install-recommends -y ${PACKAGES} \
    # Create the SoapBox Database
    && service mysql start \
    && mysql -uroot -psoapbox -e 'CREATE DATABASE soapbox;' \
    && service mysql restart \
    # Cleanup
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && apt-get clean autoclean \
    && apt-get autoremove -y

# Copy application files to root - Uses .dockerignore to ignore files
COPY ./ ${APP_DIR}/
