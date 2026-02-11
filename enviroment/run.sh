#!/bin/bash

xhost +local:docker > /dev/null

# Absolute path to EDA tools
EDA_TOOLS_PATH="$(pwd)/AMSV_2021.3_2_RHELx86/Siemens/2021-22/RHELx86/AMSV_2021.3_2"

docker run -it --rm \
  --network=host \
  --env DISPLAY=$DISPLAY \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --volume "$(pwd)":/home/user \
  --volume "$EDA_TOOLS_PATH":/opt/eda:ro \
  eda_harm:ubuntu22