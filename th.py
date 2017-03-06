from flask import Flask

BASE="/home/vagrant/tests/out/" + sys.argv[0]
file = open(BASE + '/th.log', 'w')

@app.route("/ready", methods=["POST"])
def ready():
    req = request.get_json(silent=True)
    file.write(str(req))
    lock = open(BASE + "thlock", 'w')
    lock.close()

@app.route("/error", methods=["POST"])
def error():
    req = request.get_json(silent=True)
    file.write(str(req))

@app.route("/status", methods=["POST"])
def status():
    req = request.get_json(silent=True)
    file.write(str(req))

@app.route("/done", methods=["POST"])
def done():
    req = request.get_json(silent=True)
    file.write(str(req))

if __name__ == "__main__":
    app.run("0.0.0.0") ## probably wrong, it'll clash with
