[![license](https://img.shields.io/github/license/domiey/rtsp2mjpg)](https://github.com/domiey/rtsp2mjpg/blob/main/LICENSE)


# rtsp2mjpg
## Convert RTSP/RTMP streams to MJPEG and JPEG snapshots  
A lightweight solution for OctoPrint (or other tools) to access MJPEG streaming and JPG snapshots via an RTSP/RTMP video source.

---

## ⚠️ Security Notice
**No authentication, encryption, or access control is implemented.**  
You are responsible for securing this container and the network it runs in.

Suggestions for securing access:
- Run behind a reverse proxy (e.g. Nginx, Traefik)
- Add basic auth, IP restrictions, or VPN
- Use firewall rules to limit access

> **Use at your own risk.**

---

## Features

### 🔴 MJPEG Stream
- Accessible via HTTP:
  ```
  http://<ip>:8000/mjpg.cgi
  ```

### 📸 JPEG Snapshot
- Returns a single frame from the video stream:
  ```
  http://<ip>:8000/jpg.cgi
  ```

### 🖼️ Snapshot Proxy (live snapshot image for polling)
- Continuously refreshed JPEG available at:
  ```
  http://<ip>:8090/snapshot.jpg
  ```
- Useful for OctoPrint’s "Snapshot URL" or embedding in dashboards

---

## Installation

### 📦 Docker Compose (recommended)

#### 1. Clone this repository
```bash
git clone https://github.com/domiey/rtsp2mjpg
cd rtsp2mjpg
```

#### 2. Create your `.env` file
```bash
cp example.env .env
```

#### 3. Edit `.env` with your stream URL
```env
# MJPEG Stream Config
MJPG_RESOLUTION=1080
MJPG_FPS=10
JPG_RESOLUTION=1080
SOURCE_URL=rtsp://user:pass@camera-ip/stream1

# Snapshot Proxy Config
CAM_URL=http://localhost:8000/jpg.cgi
INTERVAL=5
```

#### 4. Launch the stack
```bash
docker-compose up -d
```

---

## 🔗 Stream Access

| Endpoint              | Description                        |
|-----------------------|------------------------------------|
| `/mjpg.cgi`           | MJPEG stream                       |
| `/jpg.cgi`            | On-demand JPEG snapshot            |
| `/snapshot.jpg`       | Automatically updated snapshot     |

Example URLs (assuming local IP `192.168.1.100`):

```
http://192.168.1.100:8880/mjpg.cgi
http://192.168.1.100:8880/jpg.cgi
http://192.168.1.100:8890/snapshot.jpg
```