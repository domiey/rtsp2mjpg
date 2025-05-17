#!/bin/sh

# Start the CGI MJPEG stream server in background
/usr/local/bin/simple-cgi-server &

# Start the Flask snapshot proxy in background
python3 /data/snapshot_proxy.py &

# Wait for both processes to finish (keep container alive)
wait
