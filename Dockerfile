# Build backend
FROM golang:1.12.5 as build-backend

ARG BACKEND_TAG="master"
# Build env vars
ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64
# Minio env vars
ARG MINIO_ACCESS_KEY=access-key
ARG MINIO_SECRET_KEY=secret-key
# Test env vars
ARG TEST_STORAGE_S3_ENDPOINT=127.0.0.1:9000
ARG TEST_STORAGE_S3_ACCESS_KEY_ID=access-key
ARG TEST_STORAGE_S3_SECRET_ACCESS_KEY=secret-key
ARG TEST_STORAGE_S3_SECURE=false

# Prepare S3 storage (minio)
RUN mkdir /minio && \
	cd /minio && \
	wget https://dl.min.io/server/minio/release/linux-amd64/minio && \
	chmod +x minio

# Clone tags-drive/core
RUN mkdir /build && \
	git clone --branch $BACKEND_TAG --depth 1 --single-branch https://github.com/tags-drive/core /build

# Run minio, run tests and build a binary
RUN bash -c "nohup /minio/minio server data --quiet &" && \
	cd /build && \
	go test -v -mod=vendor ./... && \
	go build -o tags-drive -mod=vendor main.go


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