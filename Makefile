PREFIX=/usr/local

DFLAGS=-DHAVE_CONFIG_H \
	-DVERSION=\"0.9.7\" \
	-DDATA_DIR=\"$(PREFIX)/share\" \
	-DXWF_RC=\"xwf.rc\" \
	-DPLUGINDIR=\"$(PREFIX)/lib/xwf\" \
	-DINSTDIR=\"$(PREFIX)\" \
	-DTERMINAL=\"xterm\"

all: xat xcp xfi xwf

#
# inference rule
#
.SUFFIXES: .c .o
.c.o:
	$(CC) $(CFLAGS) $(DFLAGS) \
		-I. \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $< -o $@

#
# lib-src
#
lib-src/adouble.o: lib-src/adouble.c lib-src/adouble.h lib-src/i18n.h lib-src/config.h

lib-src/entry.o: lib-src/entry.c lib-src/entry.h lib-src/config.h

lib-src/gtk_dlg.o: lib-src/gtk_dlg.c lib-src/gtk_dlg.h lib-src/i18n.h lib-src/config.h

lib-src/gtk_dnd.o: lib-src/gtk_dnd.c lib-src/gtk_dnd.h lib-src/i18n.h lib-src/config.h

lib-src/gtk_exec.o: lib-src/gtk_exec.c lib-src/gtk_exec.h lib-src/i18n.h lib-src/config.h

lib-src/gtk_util.o: lib-src/gtk_util.c lib-src/gtk_util.h lib-src/i18n.h lib-src/config.h

lib-src/io.o: lib-src/io.c lib-src/io.h lib-src/config.h

lib-src/lnk.o: lib-src/lnk.c lib-src/lnk.h lib-src/config.h

lib-src/mailcap.o: lib-src/mailcap.c lib-src/mailcap.h lib-src/config.h

lib-src/reg.o: lib-src/reg.c lib-src/reg.h lib-src/config.h

lib-src/uri.o: lib-src/uri.c lib-src/uri.h lib-src/config.h

#
# xat
#
xat-src/main.o: xat-src/main.c lib-src/config.h

xat-src/callbacks.o: xat-src/callbacks.c xat-src/callbacks.h lib-src/i18n.h lib-src/config.h

xat-src/gui.o: xat-src/gui.c xat-src/gui.h lib-src/config.h

xat-src/support.o: xat-src/support.c xat-src/support.h lib-src/config.h

xat: lib-src/entry.o lib-src/mailcap.o lib-src/gtk_util.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o xat-src/main.o xat-src/callbacks.o xat-src/gui.o xat-src/support.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-o $@ \
		lib-src/entry.o lib-src/mailcap.o lib-src/gtk_util.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o xat-src/main.o xat-src/callbacks.o xat-src/gui.o xat-src/support.o

#
# xcp
#
xcp-src/xcp.o: xcp-src/xcp.c lib-src/i18n.h lib-src/config.h

xcp-src/xcp_gui.o: xcp-src/xcp_gui.c xcp-src/xcp_gui.h lib-src/i18n.h lib-src/config.h

xcp: lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/io.o lib-src/adouble.o xcp-src/xcp.o xcp-src/xcp_gui.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-o $@ \
		lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/io.o lib-src/adouble.o xcp-src/xcp.o xcp-src/xcp_gui.o

#
# xfi
#
xfi-src/main.o: xfi-src/main.c lib-src/config.h

xfi-src/callbacks.o: xfi-src/callbacks.c xfi-src/callbacks.h lib-src/config.h

xfi-src/gui.o: xfi-src/gui.c xfi-src/gui.h lib-src/config.h

xfi-src/support.o: xfi-src/support.c xfi-src/support.h lib-src/config.h

xfi: lib-src/reg.o lib-src/uri.o lib-src/io.o lib-src/entry.o xfi-src/main.o xfi-src/callbacks.o xfi-src/gui.o xfi-src/support.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-o $@ \
		lib-src/reg.o lib-src/uri.o lib-src/io.o lib-src/entry.o xfi-src/main.o xfi-src/callbacks.o xfi-src/gui.o xfi-src/support.o

#
# xwf
#
xwf-src/xwf.o: xwf-src/xwf.c xwf-src/xwf_cfg.h lib-src/i18n.h lib-src/config.h

xwf-src/gtk_get.o: xwf-src/gtk_get.c xwf-src/gtk_get.h lib-src/config.h

xwf-src/history.o: xwf-src/history.c xwf-src/history.h lib-src/config.h

xwf-src/top.o: xwf-src/top.c xwf-src/top.h lib-src/config.h

xwf-src/xwf_dnd.o: xwf-src/xwf_dnd.c xwf-src/xwf_dnd.h xwf-src/xwf_cfg.h lib-src/i18n.h lib-src/config.h

xwf-src/xwf_gui.o: xwf-src/xwf_gui.c xwf-src/xwf_gui.h xwf-src/xwf_cfg.h lib-src/i18n.h lib-src/config.h

xwf-src/xwf_icon.o: xwf-src/xwf_icon.c xwf-src/xwf_icon.h lib-src/config.h

xwf-src/xwf_misc.o: xwf-src/xwf_misc.c xwf-src/xwf_misc.h lib-src/config.h

xwf: lib-src/uri.o lib-src/io.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/gtk_util.o lib-src/reg.o lib-src/mailcap.o lib-src/gtk_exec.o lib-src/lnk.o xwf-src/xwf.o xwf-src/gtk_get.o xwf-src/history.o xwf-src/top.o xwf-src/xwf_dnd.o xwf-src/xwf_gui.o xwf-src/xwf_icon.o xwf-src/xwf_misc.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-o $@ \
		lib-src/uri.o lib-src/io.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/gtk_util.o lib-src/reg.o lib-src/mailcap.o lib-src/gtk_exec.o lib-src/lnk.o xwf-src/xwf.o xwf-src/gtk_get.o xwf-src/history.o xwf-src/top.o xwf-src/xwf_dnd.o xwf-src/xwf_gui.o xwf-src/xwf_icon.o xwf-src/xwf_misc.o

install: xat xcp xfi xwf
	install -m 755 xat xcp xfi xwf $(PREFIX)/bin
	install -m 644 doc/xwf.1 $(PREFIX)/man/man1

clean:
	rm xat xcp xfi xwf \
		lib-src/*.o \
		xat-src/*.o \
		xcp-src/*.o \
		xfi-src/*.o \
		xwf-src/*.o
