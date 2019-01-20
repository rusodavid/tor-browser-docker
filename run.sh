# Run tor browser in a container
#
 docker run -i -t -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /dev/snd:/dev/snd \
       -v /dev/shm:/dev/shm \
       -v /etc/machine-id:/etc/machine-id:ro \
       -e DISPLAY=unix$DISPLAY \
       tor


