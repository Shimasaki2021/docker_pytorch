#!/bin/bash

# bashrc等を作成
if [ ! -e ./.bashrc ]; then
    cp /etc/skel/.bash_logout ./
    cp /etc/skel/.bashrc ./
    cp /etc/skel/.profile ./

    # ★★★ パスは、CUDAバージョンに合わせて要変更 ★★★
    echo "export PATH=/usr/local/cuda-12.4/bin:\$PATH" >> .bashrc
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.4/lib64"  >> .bashrc
    sed -i 1iforce_color_prompt=yes .bashrc

    # （必須ではない）bashプロンプトにコンテナ名を表示＆色を変更
    if [ -n "$CONTAINER_NAME" ]; then
        echo "export PS1='${debian_chroot:+($debian_chroot)}\[\e[01;33m\]\u@${CONTAINER_NAME}\[\e[00m\]:\[\e[01;36m\]\w\[\e[00m\]\$ '" >> .bashrc
    fi
fi

# （必須ではない）Dockerコンテナ内でpip実行時にエラーが出ないようにする
if [ ! -d ./.pip ]; then
    mkdir -p .pip
    echo "[global]" > .pip/pip.conf
    echo "break-system-packages = true" >> .pip/pip.conf
fi

source .bashrc
exec "$@"
