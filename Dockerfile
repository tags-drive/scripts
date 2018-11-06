# Build backend
FROM golang:1.11.2 as build-backend

ARG BACKEND_TAG="master"
ENV CGO_ENABLED=0

RUN mkdir -p /temp/github.com/tags-drive/core && \
	git clone https://github.com/tags-drive/core --branch $BACKEND_TAG /temp/github.com/tags-drive/core

# Build tags-drive into /temp
RUN cd /temp/github.com/tags-drive/core && \
	go build -o /temp/tags-drive -mod=vendor cmd/tags-drive/main.go


# Build frontend
FROM node:alpine as build-frontend

ARG FRONTEND_TAG="master"

# Install git
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN mkdir -p /temp/web && \
	git clone https://github.com/tags-drive/web --branch $FRONTEND_TAG /temp/web

# Build into /temp/web/dist
RUN cd /temp/web && \
	npm i && \
	npm run build


FROM alpine

# Update
RUN apk update && apk upgrade

RUN mkdir /app && mkdir /app/web
WORKDIR /app

COPY --from=build-backend /temp/tags-drive .
COPY --from=build-frontend /temp/web/dist ./web

ENTRYPOINT [ "/app/tags-drive" ]