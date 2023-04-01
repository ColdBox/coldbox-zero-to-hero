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
FROM mcr.microsoft.com/devcontainers/universal:focal

# Metadata
LABEL maintainer "Ortus Solutions <info@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"

# Utility Packages for our buidling goodness
ENV PACKAGES "ca-certificates openssl haveged openssh-client jq git zip unzip ant"

# Install Common Dependency Binaries
RUN apt-get update && apt-get install --no-install-recommends -y ${PACKAGES} \
    # NodeJS
    #&& curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    #&& apt-get update && apt-get install --no-install-recommends -y nodejs \
    # Cleanup
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    # CommandBox
    && curl --location 'https://www.ortussolutions.com/parent/download/commandbox/type/bin' -o /tmp/box.zip \
    && unzip /tmp/box.zip -d /usr/bin \
    && chmod +x /usr/bin/box \
	&& echo "$(box version) successfully installed" \
    && box install commandbox-dotenv,commandbox-migrations,commandbox-docbox,commandbox-modules/commandbox-cflint,commandbox-cfformat \
    # Clear downloaded artifacts
    && box artifacts clean --force \
    # Cleanup CommandBox files
    && rm -rfv ~/.CommandBox/cfml/system/config/server-icons/*.* \
    # Remove any temp files
    && rm -rf ~/.CommandBox/temp/* \
    # Remove any log files
    && rm -rf ~/.CommandBox/logs/* \
    # Remove cachebox caches
    && rm -rf ~/.CommandBox/cfml/system/mdCache/* \
    # Remove the felix cache
    && rm -rf ~/.CommandBox/engine/cfml/cli/lucee-server/felix-cache/*

# Install Lucee Extensions (Optional)
# UUID (Package ID);name=Name Of Extension;version=bundle.version.number (,[UUID;name;version])
# These are available from https://download.lucee.org
# Example: 99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;name=Microsoft SQL Server (Vendor Microsoft);version=6.4.0.jre8
# ENV LUCEE_EXTENSIONS ""

# Install Adobe 2021 Modules (Optional)
# https://helpx.adobe.com/coldfusion/using/coldfusion-package-manager.html
# ENV CFPM_INSTALL=

# ColdBox Healthcheck
# ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/healthcheck"

# Copy application files to root - Uses .dockerignore to ignore files
COPY ./ ${APP_DIR}/
