#!/bin/bash
wait 10
curl -H "Content-Type:application/json" \
     -X POST \
     -d '{"TIME" : "`date -u +%Y-%m-%dT%H:%M:%S.Z`", "ARGUMENTS" : {"voltage" : 120}}' \
     localhost:8080/action/set_battery
