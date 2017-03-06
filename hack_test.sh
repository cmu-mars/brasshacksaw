#!/bin/bash

## this script runs end-to-end tests in a hacky and likely brittle way.
##
## ****** DO NOT RUN THIS ON YOUR LOCAL MACHINE ******
##
## i'm going to be very free with unchecked rm commands and system
## resources. you don't want to do that to your actual operating
## system. run it inside vagrant only.

if ! [[ `hostname | grep 'vagrant'` ]]
then
    echo "seriously: do not run this locally"
    exit 1
fi

# we assume that ~/tests/in/arg0 exists; check this later maybe
BASE="$HOME/tests/"
IN_BASE="$BASE/in/$1"
OUT_BASE="$BASE/out/$1"

# assume that /test is empty or nothing in there matters
sudo rm -rf /test
sudo mkdir -p /test
sudo chown vagrant /test

# launch python module that implements the end points in a very naive way
# and just dumps things to a file. keep track of its PID so you can kill it
# later.
mkdir -p "$OUT_BASE"
python th.py $1 &
TH_PID=$!

# copy in config file for the test number
cp "$IN_BASE/config.json" "/test/data"

# run start.sh with a timeout and redirect to a log
timeout 600 "$HOME/start.sh" &> "$OUT_BASE/start.sh.log" &

## timeout isn't probably going to be good enough here because we know that
## this stuff needs to get kill -9'ed because it's badly behaved, and it
## doesn't let us kill the th at the same time

# wait for das ready
while [ ! -f "$OUTBASE/thlock" ] ;
do
    sleep 1.0
done
rm "$OUTBASE/thlock"

# poll observe at some rate and redirect to a log
while true ; ## hook this with timeout somehow
do
    curl localhost:5000/action/observe >> "$OUTBASE/observe.log"
    sleep 0.01
done

# maybe wait and perturb (just call a script in the dir?)
$IN_BASE/perturb.sh &

# after timeout, ignoring done early?, kill everything aggressively
kill -9 $TH_PID

# move /test wholesale to ~/tests/out/##/test
mv "/test" "$OUT_BASE/"

# remake /test
sudo mkdir -p /test
sudo chown vagrant /test
