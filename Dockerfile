FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
        build-essential \
        python \
        python-dev \
        python-pip \
        python-virtualenv \
        python-setuptools \
        python-wheel \
        python3 \
        vim \
        virtualenv

# Setup directories
RUN mkdir -p /mnt/discovery && \
    chmod 777 /mnt/discovery

# Setup user and permissions
RUN useradd -m ubuntu

RUN chown -R ubuntu:ubuntu /home/ubuntu /mnt

RUN pip install -U pip
COPY . /mnt/discovery
WORKDIR /mnt/discovery
RUN pip install -r requirements.txt
