# vim:set ft=dockerfile:
FROM phusion/baseimage:0.9.18
MAINTAINER Andrew Blake <github@blakenet.uk>

ENV DEBIAN_FRONTEND noninteractive

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl git-core build-essential python libavahi-compat-libdnssd-dev libasound2-dev

RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -

RUN apt-get install -y nodejs

RUN npm install npm -g

#ENV NPM_CONFIG_LOGLEVEL info
##ENV NODE_VERSION 5.3.0
#ENV NODE_VERSION 4.2.4
#
#RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
#  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
#  && gpg --verify SHASUMS256.txt.asc \
#  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
#  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
#  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

RUN cd / && git clone https://github.com/andrew-blake/airsonos.git -b dev_docker

#RUN cd /airsonos && npm install --unsafe-perm

#RUN npm install -g airsonos

# for testing
#CMD /bin/bash -c "while sleep 2; do echo 'thinking'; done"

## Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
#
## Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#EXPOSE 5000 5001 5002 5003 5004 5005 5006 5006 5007 5008 5009 5010 5011 5012 5013 5014 5015
#
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
