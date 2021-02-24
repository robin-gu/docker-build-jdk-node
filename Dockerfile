FROM openjdk:11-jdk-buster

RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -yq && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install wget curl nodejs python3 && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 install coscmd
ADD https://coding-public-generic.pkg.coding.net/cci/release/cci-agent/linux/amd64/cci-agent .
RUN chmod a+x ./cci-agent