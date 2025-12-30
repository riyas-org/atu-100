#!/bin/bash

IMAGE_NAME="mplab-env"

case "$1" in
  build)
    echo "--- Building MPLAB Environment ---"
    docker build -t $IMAGE_NAME .
    ;;
  
  shell)
    echo "--- Launching Interactive Shell ---"
    # -v mounts your current code, --entrypoint ensures you get a prompt
    docker run --rm -it \
      -v "$(pwd):/project" \
      -w /project \
      --entrypoint /bin/bash \
      $IMAGE_NAME
    ;;

  clean)
    echo "--- Cleaning up stopped containers and dangling layers ---"
    docker container prune -f
    docker image prune -f
    ;;

  nuclear)
    echo "--- WARNING: Deleting ALL images, volumes, and cache ---"
    docker system prune -a -f --volumes
    docker builder prune -a -f
    ;;

  *)
    echo "Usage: ./manage.sh {build|shell|clean|nuclear}"
    echo "  build   : Create the image"
    echo "  shell   : Run and enter the container"
    echo "  clean   : Remove temporary/broken layers"
    echo "  nuclear : Reclaim ALL disk space (deletes the 4GB image)"
    ;;
esac

