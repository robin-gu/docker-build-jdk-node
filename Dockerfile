FROM openjdk:11-jdk-buster

RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -yq && \
    DEBIAN_FRONTEND=noninteractive apt-get install wget curl nodejs && \
    rm -rf /var/lib/apt/lists/*
RUN bash install.sh