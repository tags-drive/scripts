# Build backend
FROM golang:1.12.5 as build-backend

ARG BACKEND_TAG="master"

ENV CGO_ENABLED=0 \
	GOOS=linux \
	GOARCH=amd64

RUN mkdir /temp && \
	git clone --branch $BACKEND_TAG --depth 1 --single-branch https://github.com/tags-drive/core /temp

RUN cd /temp && \
	go test -mod=vendor ./... && \
	go build -o tags-drive -mod=vendor ./cmd/tags-drive/main.go


# Build frontend
FROM node:12.2.0 as build-frontend

ARG FRONTEND_TAG="master"

RUN mkdir -p /temp/web && \
	git clone --branch $FRONTEND_TAG --depth 1 --single-branch https://github.com/tags-drive/web /temp/web

# Build into /temp/web/dist
RUN cd /temp/web && \
	npm i && \
	npm run build


# Build the final image
FROM alpine:3.9.4

RUN apk update && \
	apk add --no-cache tzdata ca-certificates

WORKDIR /app
RUN mkdir /app/web

COPY --from=build-backend /temp/tags-drive .
COPY --from=build-frontend /temp/web/dist ./web

EXPOSE 80

ENTRYPOINT [ "./tags-drive" ]