#!/bin/bash

# コンテナ名。docker_run.shのCONTAINER_NAMEと合わせること
CONTAINER_NAME="pytorch_gpu"

docker exec -it ${CONTAINER_NAME} /bin/bash
