FROM node:5.0.0

# Do installation and updates first - this means the 'ADD' operations below
# won't invalidate the cache Docker has of the command's result

RUN apt-get update && apt-get -y install fontforge;

RUN mkdir /gaia-icons

# To optimise the caching - add package.json and npm install before doing
# anything
WORKDIR /gaia-icons

ADD package.json /gaia-icons/package.json
RUN npm install

# Now add everything (Docker can tell if there are changes on your file system
# so will rebuild only if something has changed - the .dockerignore file
# ignores node_modules
ADD . /gaia-icons

ENV OUTPUT_DIR=/gaia-icons-host
CMD node_modules/.bin/grunt && \
    cp output/embedded/gaia-icons.css /gaia-icons-host/gaia-icons-embedded.css && \
    cp output/files/gaia-icons.css /gaia-icons-host/gaia-icons.css && \
    cp output/files/fonts/gaia-icons.ttf /gaia-icons-host/fonts/gaia-icons.ttf && \
    cp output/files/gaia-icons.html /gaia-icons-host/index.html
