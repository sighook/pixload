include config.mk

MAN = $(subst .1.pod,.1,$(wildcard *.pod))
SRC = $(MAN:.1=)

all: $(SRC) $(MAN)

%: %.in
	sed "s/@VERSION@/$(VERSION)/" $< > $@

%: %.pod
	pod2man --nourls -r $(VERSION) -c ' ' -n $(basename $@) \
		-s $(subst .,,$(suffix $@)) $< > $@

install: all
	install -m 755 -D -t $(DESTDIR)$(PREFIX)/bin/     $(SRC)
	install -m 644 -D -t $(DESTDIR)$(MANPREFIX)/man1/ $(MAN)

uninstall:
	cd $(DESTDIR)$(PREFIX)/bin/     && rm $(SRC)
	cd $(DESTDIR)$(MANPREFIX)/man1/ && rm $(MAN)

clean:
	rm -f $(SRC) $(MAN)

.PHONY: all install uninstall clean
