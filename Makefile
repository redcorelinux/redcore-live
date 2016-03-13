SUBDIRS =
DESTDIR = 
UBINDIR ?= /usr/bin
LIBDIR ?= /usr/lib
SBINDIR ?= /sbin
USBINDIR ?= /usr/sbin
BINDIR ?= /bin
LIBEXECDIR ?= /usr/libexec
SYSCONFDIR ?= /etc
SYSTEMD_UNITDIR ?= $(LIBDIR)/systemd/system

all:
	for d in $(SUBDIRS); do $(MAKE) -C $$d; done

clean:
	for d in $(SUBDIRS); do $(MAKE) -C $$d clean; done

install:
	for d in $(SUBDIRS); do $(MAKE) -C $$d install; done

	install -d $(DESTDIR)/$(LIBEXECDIR)
	install -m 0755 kogaionlive.sh $(DESTDIR)/$(LIBEXECDIR)/
	install -d $(DESTDIR)/$(SYSTEMD_UNITDIR)/
	install -m 0644 kogaionlive.service $(DESTDIR)/$(SYSTEMD_UNITDIR)/
