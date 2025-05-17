FROM golang:1.17.7-alpine3.15 as build

# Install build dependencies
RUN apk --no-cache --update upgrade && apk --no-cache add git build-base

# Clone and build simple-cgi-server
RUN cd /go && git clone https://github.com/mback2k/simple-cgi-server.git
WORKDIR /go/simple-cgi-server
RUN go get
RUN go build -ldflags="-s -w"
RUN chmod +x simple-cgi-server

# ---------- Runtime image ----------
FROM ghcr.io/home-assistant/amd64-base-python:3.10-alpine3.15

# Install system packages and ffmpeg
RUN apk --no-cache --update upgrade && \
    apk --no-cache add ca-certificates bash ffmpeg

# Install Python packages for snapshot proxy
RUN pip install --no-cache-dir flask requests

# Copy CGI binary from builder stage
COPY --from=build /go/simple-cgi-server/simple-cgi-server /usr/local/bin/simple-cgi-server

# Create user and group
RUN addgroup -g 8080 -S serve && \
    adduser -u 8080 -h /data -S -D -G serve serve

# Copy application files
COPY --chown=8080:8080 rtsp2mjpg /data
COPY rtsp2mjpg/snapshot_proxy.py /data/snapshot_proxy.py

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY etc /etc

# Set working directory and user
WORKDIR /data
USER serve

# Expose CGI and snapshot ports
EXPOSE 8000 8090

# Default environment variables
ENV MJPG_RESOLUTION=-1
ENV MJPG_FPS=5
ENV JPG_RESOLUTION=-1
ENV SOURCE_URL=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4

# Run both CGI server and snapshot proxy
ENTRYPOINT ["/entrypoint.sh"]
