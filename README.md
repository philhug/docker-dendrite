# Docker image to install the dev version of matrix dendrite

[![Build Status](https://travis-ci.org/AVENTER-UG/docker-dendrite.svg?branch=master)](https://travis-ci.org/AVENTER-UG/docker-dendrite)

Please don't forget to donate a small fee: [![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/AVENTER/donate)

This docker image is installing the dev verison of matrix dendrite. It's not a up and running version. Please read the dendrite  [install guide](https://github.com/matrix-org/dendrite/blob/master/INSTALL.md).

## Github Repo

[https://github.com/AVENTER-UG](https://github.com/AVENTER-UG)

## Security 

We verify our image automaticly by clair. If you want to see the current security status, please have a look in travis-ci.

## Dockerfile

```
FROM golang:1.9-alpine
MAINTAINER Andreas Peters <support@aventer.biz>

ENV DOMAIN "localhost"
ENV CLIENT_URL "http://localhost:7771"
ENV SYNC_URL "http://localhost:7773"
ENV MEDIA_URL "http://localhost:7774"
ENV ROOM_URL "http://localhost:7775" 
ENV FUNCTION "CLIENT_PROXY"

VOLUME /config
VOLUME /var/dendrite/media

RUN apk add --update git openssl && \
    mkdir /dendrite && \
    git clone https://github.com/matrix-org/dendrite /dendrite && \
    cd /dendrite && \
    go get github.com/constabulary/gb/... && \
    gb build

ADD run.sh /run.sh

EXPOSE 8008

ENTRYPOINT ["/run.sh"]

```