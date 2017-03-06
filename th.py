import sys
from flask import Flask, request

## zero extend
num = 0
if sys.argv[1] < 10:
    num = "0%s" % sys.argv[1]
else:
    num = sys.argv[1]

app = Flask(__name__)
BASE = "/home/vagrant/tests/out/" + num
F = open(BASE + '/th.log', 'w')

@app.route("/ready", methods=["POST"])
def ready():
    req = request.get_json(silent=True)
    F.write(str(req))
    lock = open(BASE + "/thlock", 'w')
    lock.close()

@app.route("/error", methods=["POST"])
def error():
    req = request.get_json(silent=True)
    F.write(str(req))

@app.route("/status", methods=["POST"])
def status():
    req = request.get_json(silent=True)
    F.write(str(req))

@app.route("/done", methods=["POST"])
def done():
    req = request.get_json(silent=True)
    F.write(str(req))

if __name__ == "__main__":
    app.run("0.0.0.0") ## probably wrong, it'll clash with
