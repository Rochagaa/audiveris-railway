FROM ghcr.io/audiveris/audiveris:latest

WORKDIR /data

CMD ["tail", "-f", "/dev/null"]
