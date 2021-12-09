FROM alpine:edge

RUN apk add --update --no-cache \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	make file perl perl-gd perl-image-exiftool perl-string-crc32

COPY . /pixload
RUN sed -i '/install .* $(DESTDIR)$(MANPREFIX)/d' /pixload/Makefile && \
	make -C /pixload PREFIX=/usr install && rm -rf /pixload

WORKDIR /pixload
ENTRYPOINT ["/bin/sh"]
