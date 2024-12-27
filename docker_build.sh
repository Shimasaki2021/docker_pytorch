#!/bin/bash

# コンテナイメージ名。任意の名前でOK
CONTAINER_IMAGE_NAME="cuda_ubuntu:12.4-24.04"

OPT_NOCACHE=""
if [ $# = 1 ] && [ ${1} = "rebuild" ]; then
    OPT_NOCACHE="--no-cache"
fi

# 実行コマンドのecho。なくてもよい
echo docker build . -t ${CONTAINER_IMAGE_NAME} \
               --build-arg USERNAME=${USER} \
               --build-arg GROUPNAME=${USER} \
               --build-arg UID=$(id -u) \
               --build-arg GID=$(id -g) \
               ${OPT_NOCACHE}

# Dockerコンテナに現在のユーザーを追加
docker build . -t ${CONTAINER_IMAGE_NAME} \
               --build-arg USERNAME=${USER} \
               --build-arg GROUPNAME=${USER} \
               --build-arg UID=$(id -u) \
               --build-arg GID=$(id -g) \
               ${OPT_NOCACHE}
