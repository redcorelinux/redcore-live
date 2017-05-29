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
OPENRC_INITDIR ?= $(SYSCONFDIR)/init.d

all:
	for d in $(SUBDIRS); do $(MAKE) -C $$d; done

clean:
	for d in $(SUBDIRS); do $(MAKE) -C $$d clean; done

install:
	for d in $(SUBDIRS); do $(MAKE) -C $$d install; done

	install -d $(DESTDIR)/$(LIBEXECDIR)
	install -m 0755 redcorelive-systemd.sh $(DESTDIR)/$(LIBEXECDIR)/
	install -m 0755 redcorelive-openrc.sh $(DESTDIR)/$(LIBEXECDIR)/
	install -d $(DESTDIR)/$(SYSTEMD_UNITDIR)/
	install -m 0644 redcorelive.service $(DESTDIR)/$(SYSTEMD_UNITDIR)/
	install -d $(DESTDIR)/$(OPENRC_INITDIR)/
	install -m 0755 redcorelive.initd $(DESTDIR)/${OPENRC_INITDIR}/redcorelive
