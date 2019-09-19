
FROM ubuntu:latest

# Dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libgd-perl libimage-exiftool-perl libstring-crc32-perl

#Project Staging
RUN mkdir -p /opt/pixload
COPY ./ /opt/pixload

CMD perl /opt/pixload/jpeg.pl
