#!/bin/sh

export LD_LIBRARY_PATH=/usr/prog/mjpg-streamer

(
  cd /usr/prog/mjpg-streamer || exit 1
  # wait up to 30s for the camera
  i=0
  while [ ! -e /dev/video0 ] && [ "$i" -lt 30 ]; do sleep 1; i=$((i+1)); done
  mkdir -p /usr/data/logs
  # relaunch if mjpg_streamer ever exits
  while true; do
    ./mjpg_streamer \
      -i "input_uvc.so -d /dev/video0 -r 1280x720 -f 30" \
      -o "output_http.so -p 8080 -w www" \
      >/usr/data/logs/mjpg.log 2>&1
    sleep 3
  done
) &