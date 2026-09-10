FROM --platform=$BUILDPLATFORM alpine:3.21 AS builder
RUN apk add --no-cache wget ca-certificates
ARG TARGETOS TARGETARCH
RUN case "$TARGETARCH" in \
      arm64) ARCH="arm64" ;; \
      amd64) ARCH="x64" ;; \
      *) exit 1 ;; \
    esac && \
    wget -qO /supermemory-server \
      "https://github.com/supermemoryai/supermemory/releases/download/server-v0.0.8/supermemory-server-${TARGETOS}-${ARCH}" && \
    chmod +x /supermemory-server

FROM debian:bookworm-slim
RUN apt-get update -qq && apt-get install -y -qq ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /supermemory-server /usr/local/bin/supermemory-server
WORKDIR /data
VOLUME /data
EXPOSE 6767
ENTRYPOINT ["/usr/local/bin/supermemory-server"]
