from flask import Flask, send_file
import requests, threading, time, os, sys

# Require CAM_URL to be set
CAM_URL = os.environ.get("CAM_URL")
if not CAM_URL:
    sys.exit("Error: CAM_URL environment variable is required.")

# Optional INTERVAL with default fallback
INTERVAL = float(os.environ.get("INTERVAL", 5))
IMG_PATH = "/tmp/snapshot.jpg"

app = Flask(__name__)

def fetch_image():
    while True:
        try:
            r = requests.get(CAM_URL, timeout=3)
            if r.ok:
                with open(IMG_PATH, "wb") as f:
                    f.write(r.content)
        except Exception as e:
            print("Snapshot fetch error:", e)
        time.sleep(INTERVAL)

@app.route("/snapshot.jpg")
def snapshot():
    return send_file(IMG_PATH, mimetype="image/jpeg")

if __name__ == "__main__":
    threading.Thread(target=fetch_image, daemon=True).start()
    app.run(host="0.0.0.0", port=8090)