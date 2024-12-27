#!/bin/bash

# コンテナイメージ名。docker_build.shと合わせること
CONTAINER_IMAGE_NAME="cuda_ubuntu:12.4-24.04"

# コンテナ名。任意の名前でOK
CONTAINER_NAME=pytorch_gpu

# コンテナ内のホームディレクトリのマウント先。現在ディレクトリ直下に、/home/xxx/を作成
CONTAINER_HOMEDIR=$(pwd)/$HOME

# ホームディレクトリのマウント先となる空ディレクトリを、ホスト側（Ubuntu）に作成
if [ ! -d ${CONTAINER_HOMEDIR} ]; then
    mkdir -p ${CONTAINER_HOMEDIR}
fi

docker run -it --rm --gpus all \
            --name ${CONTAINER_NAME} \
            -u $(id -u):$(id -g) \
            --mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
            --mount type=bind,source=/mnt/wslg,target=/mnt/wslg \
            --mount type=bind,source=${CONTAINER_HOMEDIR},target=${HOME} \
            --env CONTAINER_NAME=${CONTAINER_NAME} \
            --env DISPLAY=${DISPLAY} --env WAYLAND_DISPLAY=${WAYLAND_DISPLAY} \
            --env XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} \
            -w ${HOME} \
            ${CONTAINER_IMAGE_NAME} \
            /bin/bash
