from flask import Flask
import requests
import psutil

app = Flask(__name__)


@app.route("/")
def index():
    instance_id = requests.get("http://169.254.169.254/latest/meta-data/instance-id").text
    return "Instance ID: {}".format(instance_id)


@app.route("/health")
def health():
    cpu_percent = psutil.cpu_percent()
    virtual_memory = psutil.virtual_memory()
    available_memory = virtual_memory.available
    total_memory = virtual_memory.total

    if cpu_percent > 50 or available_memory / total_memory < 0.5:
        return "Instance is unhealthy", 500
    else:
        return "Instance is healthy", 200


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)