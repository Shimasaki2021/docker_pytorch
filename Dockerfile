FROM ubuntu:24.04

# ------------------
#  一般ユーザー追加
# ------------------
ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=1000
ARG GID=1000

#   追加しようとしているユーザー／グループが存在していれば削除
RUN if [ `cat /etc/group | grep ${GID} | awk -F':' '{print $1}'` != "" ]; then \
        groupdel -f `cat /etc/group | grep ${GID} | awk -F':' '{print $1}'`; \
fi
RUN if [ `cat /etc/passwd | grep ${UID} | awk -F':' '{print $1}'` != "" ]; then \
        userdel -r `cat /etc/passwd | grep ${UID} | awk -F':' '{print $1}'`; \
fi

RUN groupadd -g ${GID} ${GROUPNAME} && \
	useradd -m -s /bin/bash -u ${UID} -g ${GID} ${USERNAME} && \
    mkdir -p /run/user/${UID} && \
    chown -R ${USERNAME}:${GROUPNAME} /run/user/${UID} && \
    chmod 700 /run/user/${UID}

# ------------------------------
#  Ubuntu更新、アプリインストール
# ------------------------------

# OpenGL関連(labelImgで「 MESA: error: ZINK: failed to choose pdev」というエラーが出るので、その対策)
RUN apt-get update && \
    apt-get install -y software-properties-common

RUN apt-get update && \
    add-apt-repository ppa:kisak/kisak-mesa

# wget以外は必須ではない。
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget && \
    apt-get install -y htop vim nano less x11-apps git

# ---------------------------------------
#  CUDA(NVIDIA GPU開発環境)のインストール
# ---------------------------------------
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb

# ↓Ubuntu23.04以降でCUDAのインストールに必要なコマンド
RUN echo "deb http://archive.ubuntu.com/ubuntu/ jammy universe" >> /etc/apt/sources.list.d/jammy.list
RUN echo "Package: *\n\
    Pin: release n=jammy\n\
    Pin-Priority: -10\n\n\
    Package: libtinfo5\n\
    Pin: release n=jammy\n\
    Pin-Priority: 990" >> /etc/apt/preferences.d/pin-jammy
# ↑Ubuntu23.04以降でCUDAのインストールに必要なコマンド

# ★★★ cuda-toolkit-12-4は、GPUに合わせたバージョンを要選択 ★★★
RUN apt-get update && \
    apt-get -y install cuda-toolkit-12-4

RUN rm cuda-keyring_1.1-1_all.deb

# -----------------------
#  PyTorchのインストール
# -----------------------
RUN apt-get update && \
    apt-get install -y python3-pip

RUN mkdir -p /root/.pip && \
    echo "[global]" > /root/.pip/pip.conf && \
    echo "break-system-packages = true" >> /root/.pip/pip.conf

# ★★★ PyTorch公式HPで調べた、CUDAバージョンに対応するコマンドをここに記載 ★★★
# RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir \
            torch \
            torchvision \
            torchaudio

RUN python3 -m pip install --no-cache-dir \
            jupyter \
            ipykernel

RUN python3 -m pip install --no-cache-dir \
            scikit-image \
            matplotlib \
            opencv-python \
            tqdm \
            scikit-learn \
            labelImg

# ★★★ labelImg(1.8.6)のbug修正 (labelImg/pythonのバージョンが違う場合は要カスタマイズ) ★★★
#   https://note.com/nagisa_hoshimori/n/n4bb4a4a5019d
#   labelImgをインストールしない場合は、ここはCommentOut
COPY tool_bugfix/labelimg_1.8.6/labelImg/labelImg.py /usr/local/lib/python3.12/dist-packages/labelImg/
COPY tool_bugfix/labelimg_1.8.6/libs/canvas.py /usr/local/lib/python3.12/dist-packages/libs/

# -------------------------------
#  Dockerコンテナ起動時スクリプト
# -------------------------------
COPY container_init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/container_init.sh
ENTRYPOINT [ "/usr/local/bin/container_init.sh" ]
