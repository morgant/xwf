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
# lib-src
#
lib-src/adouble.o: lib-src/adouble.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/entry.o: lib-src/entry.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/gtk_dlg.o: lib-src/gtk_dlg.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-I. \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/gtk_dnd.o: lib-src/gtk_dnd.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/gtk_exec.o: lib-src/gtk_exec.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/gtk_util.o: lib-src/gtk_util.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/io.o: lib-src/io.c
	$(CC) $(CFLAGS) $(DFLAGS) -c $? -o $@

lib-src/lnk.o: lib-src/lnk.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/mailcap.o: lib-src/mailcap.c
	$(CC) $(CFLAGS) $(DFLAGS) -c $? -o $@

lib-src/reg.o: lib-src/reg.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/uri.o: lib-src/uri.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

#
# xat
#
xat-src/main.o: xat-src/main.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xat-src/callbacks.o: xat-src/callbacks.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xat-src/gui.o: xat-src/gui.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xat-src/support.o: xat-src/support.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xat: lib-src/entry.o lib-src/mailcap.o lib-src/gtk_util.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o xat-src/main.o xat-src/callbacks.o xat-src/gui.o xat-src/support.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		$? -o $@

#
# xcp
#
xcp-src/xcp.o: xcp-src/xcp.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xcp-src/xcp_gui.o: xcp-src/xcp_gui.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xcp: lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/io.o lib-src/adouble.o xcp-src/xcp.o xcp-src/xcp_gui.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		$? -o $@

#
# xfi
#
xfi-src/main.o: xfi-src/main.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xfi-src/callbacks.o: xfi-src/callbacks.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xfi-src/gui.o: xfi-src/gui.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xfi-src/support.o: xfi-src/support.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xfi: lib-src/reg.o lib-src/uri.o lib-src/io.o lib-src/entry.o xfi-src/main.o xfi-src/callbacks.o xfi-src/gui.o xfi-src/support.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		$? -o $@

#
# xwf
#
xwf-src/xwf.o: xwf-src/xwf.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf-src/gtk_get.o: xwf-src/gtk_get.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf-src/history.o: xwf-src/history.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf-src/top.o: xwf-src/top.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf-src/xwf_dnd.o: xwf-src/xwf_dnd.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf-src/xwf_gui.o: xwf-src/xwf_gui.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf-src/xwf_icon.o: xwf-src/xwf_icon.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf-src/xwf_misc.o: xwf-src/xwf_misc.c
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

xwf: lib-src/uri.o lib-src/io.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/gtk_util.o lib-src/reg.o lib-src/mailcap.o lib-src/gtk_exec.o lib-src/lnk.o xwf-src/xwf.o xwf-src/gtk_get.o xwf-src/history.o xwf-src/top.o xwf-src/xwf_dnd.o xwf-src/xwf_gui.o xwf-src/xwf_icon.o xwf-src/xwf_misc.o
	$(CC) $(CFLAGS) $(DFLAGS) \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		$? -o $@

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
