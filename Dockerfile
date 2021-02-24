FROM openjdk:11-jdk-buster

RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -yq && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install wget curl nodejs && \
    rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://bootstrap.pypa.io/get-pip.py | python -
ADD https://coding-public-generic.pkg.coding.net/cci/release/cci-agent/linux/amd64/cci-agent .
RUN chmod a+x ./cci-agent