FROM ubuntu:22.04
RUN mkdir -p /workspace
RUN apt update && apt install -y lua5.4
WORKDIR /workspace
