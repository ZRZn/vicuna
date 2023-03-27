# 基础镜像 3.7G
FROM nvidia/cuda:11.7.0-cudnn8-devel-ubuntu18.04

# 指定工作目录
WORKDIR /root/workdir

# 更新, 并安装工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev \
    openssh-client \
    gcc \
    libc6-dev \
    vim \
    wget \
    git \
    gdb \
    htop \
    redis \
    iputils-ping \
    curl

RUN DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# 下载共享文件下载工具并配置
RUN wget -q https://cdn.233xyx.com/1677668033571_217.zip -O mc_aml.tar && tar -xvf mc_aml.tar && rm -rf mc_aml.tar && \
    echo "0753e5edd0de0ce82fac495af59b2c2e34ba1ce41fd0ef5ef32f568f3379616b mc" | sha256sum --check && \
    echo "2e84148cfaaa61950ec5a3de42e51b885cdb74329dbeb8a4fa26333fb3a745b5 mc_aml_filestorage_put" | sha256sum --check && \
    echo "c7ff9bda899a8d4ce1bf708a07f4635884ac31faed8eb1e8cd6728168b4a1829 mc_aml_filestorage_get" | sha256sum --check && \
    chmod +x mc mc_aml_filestorage_get mc_aml_filestorage_put && \
    mv mc mc_aml_filestorage_get mc_aml_filestorage_put /usr/local/bin/ &&\
    mc config host add minio http://minio.metaapp.cn 9JE4ETF9XDVV2BSMUOWF UMgo+dhtj2REAYe6ta++gyWQ3rp8I+975fqHOuRT --api s3v4



# 配置cuda
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:/usr/local/cuda-11.7/lib64:/usr/local/cuda/lib64
RUN cd /usr/local/cuda/lib64 && \
    ln -s libcusolver.so.11 libcusolver.so.10


# 配置git
COPY .ssh /root/.ssh
ADD .gitconfig /root/
RUN chmod 644 /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/authorized_keys /root/.ssh/id_rsa /root/.ssh/known_hosts


#安装conda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
SHELL ["/bin/bash", "-c"]
RUN export http_proxy=http://10.0.24.120:7895 \
    && export https_proxy=http://10.0.24.120:7895
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN conda create -n llm python=3.10 \
    && source activate llm \
    && conda install numpy \
    && conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia \
    && pip install git+https://github.com/huggingface/transformers.git \
    && pip install git+https://github.com/huggingface/peft.git \
    && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
    && pip install datasets loralib sentencepiece accelerate bitsandbytes gradio appdirs
    