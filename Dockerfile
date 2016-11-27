FROM alpine:latest

WORKDIR /install

RUN apk update && apk upgrade
