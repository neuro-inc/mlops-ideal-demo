FROM ghcr.io/neuro-inc/base:v22.5.0-runtime

COPY apt.txt .
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub && \
    apt-get -qq update && \
    cat apt.txt | tr -d "\r" | xargs -I % apt-get -qq install --no-install-recommends % && \
    apt-get -qq clean && \
    apt-get autoremove -y --purge && \
    rm -rf apt.txt /var/lib/apt/lists/* /tmp/* ~/*

COPY setup.cfg .

COPY requirements.txt .
RUN pip install --progress-bar=off -U --no-cache-dir -r requirements.txt

RUN ssh-keygen -f /id_rsa -t rsa -N neuro -q
