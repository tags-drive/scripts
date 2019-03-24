# Build backend
FROM golang:1.11.2 as build-backend

ARG BACKEND_TAG="master"
ENV CGO_ENABLED=0

RUN mkdir -p /temp/github.com/tags-drive/core && \
	git clone --branch $BACKEND_TAG --depth 1 --single-branch https://github.com/tags-drive/core /temp/github.com/tags-drive/core

RUN cd /temp/github.com/tags-drive/core && \
	go test -mod=vendor ./... && \
	go build -o /temp/tags-drive -mod=vendor main.go


# Build frontend
FROM node:alpine as build-frontend

ARG FRONTEND_TAG="master"

# Install git
RUN apk update && apk upgrade && \
	apk add --no-cache bash git openssh

RUN mkdir -p /temp/web && \
	git clone --branch $FRONTEND_TAG --depth 1 --single-branch https://github.com/tags-drive/web /temp/web

# Build into /temp/web/dist
RUN cd /temp/web && \
	npm i && \
	npm run build


# Build the final image
FROM alpine

# Update
RUN apk update && apk upgrade

RUN mkdir /app && mkdir /app/web
WORKDIR /app

COPY --from=build-backend /temp/tags-drive .
COPY --from=build-frontend /temp/web/dist ./web

ENTRYPOINT [ "/app/tags-drive" ]