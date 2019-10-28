FROM alpine:edge

RUN apk add --update --no-cache \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	perl perl-gd perl-image-exiftool perl-string-crc32

WORKDIR /pixload
ENTRYPOINT ["/bin/sh"]
