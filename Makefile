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

	install -d $(DESTDIR)/$(SBINDIR)
	install -d $(DESTDIR)/$(BINDIR)

	install -d $(DESTDIR)/$(USBINDIR)
	
	install -d $(DESTDIR)/$(UBINDIR)

	install -d $(DESTDIR)/$(SYSCONFDIR)/kogaion

	install -d $(DESTDIR)/$(SYSTEMD_UNITDIR)/
