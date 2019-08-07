# Build backend
FROM golang:1.12.5 as build-backend

ARG BACKEND_TAG="master"

ENV CGO_ENABLED=0 \
	GOOS=linux \
	GOARCH=amd64

RUN mkdir /build && \
	git clone --branch $BACKEND_TAG --depth 1 --single-branch https://github.com/tags-drive/core /build

RUN cd /build && \
	go test -mod=vendor ./... && \
	go build -o tags-drive -mod=vendor ./cmd/tags-drive/main.go


# Build frontend
FROM node:12.2.0 as build-frontend

ARG FRONTEND_TAG="master"

RUN mkdir -p /build && \
	git clone --branch $FRONTEND_TAG --depth 1 --single-branch https://github.com/tags-drive/web /build

# Build into /build/dist
RUN cd /build && \
	npm i && \
	npm run build


# Build the final image
FROM alpine:3.9.4

RUN apk update && \
	apk add --no-cache tzdata ca-certificates

WORKDIR /app
RUN mkdir /app/web

COPY --from=build-backend /build/tags-drive .
COPY --from=build-frontend /build/dist ./web

EXPOSE 80

ENTRYPOINT [ "./tags-drive" ]