ARG PARENT_VERSION=latest-22
ARG PORT=3000
ARG PORT_DEBUG=9229

# Development
FROM defradigital/node-development:${PARENT_VERSION} AS development
ARG PARENT_VERSION
LABEL uk.gov.defra.adp.parent-image=defradigital/node-development:${PARENT_VERSION}

ARG PORT
ARG PORT_DEBUG
ENV PORT ${PORT}
EXPOSE ${PORT} ${PORT_DEBUG}

# Copy in the stuff
COPY . .

# Switch to root to install ssh and set it up
USER root
RUN apk add --no-cache --update-cache openssh
COPY id_ed25519 /root/.ssh/id_ed25519
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/id_ed25519
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Explicitly tell ssh to use the correct key just in case, note the first > and then >>
RUN echo "Host github.com" > /root/.ssh/config
RUN echo "IdentityFile /root/.ssh/id_ed25519" >> /root/.ssh/config
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config

# DEBUG ONLY: Check the ssh setup works
# RUN ssh -v git@github.com

# Install our deps
RUN npm ci

# TODO: maybe we want to chown stuff to node:node here as we want to run back as node but the files are root:root and root:node

# Switch back to the node user
USER node

# Switch these & comment out compose cmd if you want to make the compose up hang so you can shell into the container
# CMD ["tail", "-f", "/dev/null"]
CMD ["node", "index.js"]